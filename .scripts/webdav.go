/*?sr/bin/env go run "$0" "$@"; exit "$?" #*/
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"time"
)

func main() {
	run()
}

// Run WebDAV https server via `rclone serve`
func run() {
	homePath, err := os.UserHomeDir()
	if err != nil {
		log.Fatalf("failed to get user home dir")
	}

	dirPtr := flag.String("d", homePath, "Directory path to share via rclone")
	userPtr := flag.String("u", "user", "WebDAV user")
	passPtr := flag.String("p", "pass", "WebDAV pass")
	hostPtr := flag.String("h", "127.0.0.1", "WebDAV host")
	portPtr := flag.Int("port", 8443, "WebDAV port")
	exitPtr := flag.Bool("exit", false, "Terminate process on specified port")

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [options]\n\nOptions:\n", filepath.Base(os.Args[0]))
		flag.PrintDefaults()
	}

	flag.Parse()

	if *exitPtr == true {
		freeTCPPort(*portPtr, 2*time.Second)
		return
	}

	// check deps
	deps := []string{"rclone", "openssl", "lsof"}
	checkDependencies(deps)

	// generate cert
	certPath := filepath.Join(homePath, ".local/share/certs", "webdav")
	if err := generateCert(certPath, *hostPtr); err != nil {
		log.Fatalf("failed to generate certificate: %v", err)
	}

	// run decoupled `rclone serve webdav` process
	addr := fmt.Sprintf("%s:%d", *hostPtr, *portPtr)
	certFile := filepath.Join(certPath, "cert.pem")
	keyFile := filepath.Join(certPath, "key.pem")

	rcloneCmd := exec.Command("rclone", "serve", "webdav", *dirPtr,
		"--addr", addr,
		"--user", *userPtr,
		"--pass", *passPtr,
		"--cert", certFile,
		"--key", keyFile,
	)
	rcloneCmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}

	var stderr strings.Builder
	rcloneCmd.Stderr = &stderr

	if err := rcloneCmd.Start(); err != nil {
		log.Fatalf("failed to start rclone: %v", err)
	}

	exitChan := make(chan error, 1)
	go func() {
		exitChan <- rcloneCmd.Wait()
	}()

	timer := time.NewTimer(200 * time.Millisecond)
	defer timer.Stop()

	select {
	case <-exitChan:
		log.Fatalf("rclone failed to stay alive:\n\n%s", stderr.String())
	case <-timer.C:
		break
	}

	fmt.Printf("WebDAV server (PID: %d) running at:\n", rcloneCmd.Process.Pid)
	printInterfaceAddresses(*portPtr, "https://")
}

// generateCert generates certificate for WebDAV in certPath.
// It renews the certificate if it is expired OR if the host has changed.
func generateCert(certPath, host string) error {
	if err := os.MkdirAll(certPath, 0700); err != nil {
		return err
	}

	certFile := filepath.Join(certPath, "cert.pem")
	keyFile := filepath.Join(certPath, "key.pem")
	hostFile := filepath.Join(certPath, ".host")

	needsRenew := func() bool {
		if _, err := os.Stat(certFile); os.IsNotExist(err) {
			return true
		}

		checkCmd := exec.Command("openssl", "x509", "-checkend", "0", "-noout", "-in", certFile)
		if err := checkCmd.Run(); err != nil {
			return true
		}

		savedHost, err := os.ReadFile(hostFile)
		if err != nil || strings.TrimSpace(string(savedHost)) != host {
			return true
		}

		return false
	}()

	if !needsRenew {
		return nil
	}

	subj := fmt.Sprintf("/CN=%s", host)
	genCmd := exec.Command("openssl", "req", "-x509", "-nodes", "-days", "365",
		"-newkey", "rsa:2048",
		"-keyout", keyFile,
		"-out", certFile,
		"-subj", subj,
	)

	if err := genCmd.Run(); err != nil {
		return err
	}

	return os.WriteFile(hostFile, []byte(host), 0600)
}

// freePorts frees TCP port, returns:
// - false, when port has been free
// - true, when port has been freed
func freeTCPPort(port int, killAfter time.Duration) bool {
	cmd := exec.Command("lsof", "-t", "-i", fmt.Sprintf("tcp:%d", port))
	output, err := cmd.Output()
	if err != nil {
		return false
	}

	for pidStr := range strings.FieldsSeq(string(output)) {
		pid, err := strconv.Atoi(pidStr)
		if err != nil {
			continue
		}

		proc, err := os.FindProcess(pid)
		if err != nil {
			continue
		}

		_ = proc.Signal(syscall.SIGTERM)
		killCtx, cancel := context.WithTimeout(context.Background(), killAfter)

		ticker := time.NewTicker(100 * time.Millisecond)
		alive := true

	WaitLoop:
		for alive {
			select {
			case <-killCtx.Done():
				break WaitLoop
			case <-ticker.C:
				if err := proc.Signal(syscall.Signal(0)); err != nil {
					alive = false
				}
			}
		}
		ticker.Stop()
		cancel()

		if alive {
			_ = proc.Signal(syscall.SIGKILL)
		}
	}

	return true
}

// printInterfaceAddresses prints all active local IPv4 interface addresses
// formatted as accessible URLs using the provided protocol and port.
func printInterfaceAddresses(port int, protocol string) {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return
	}

	for _, a := range addrs {
		ipnet, ok := a.(*net.IPNet)
		if !ok {
			continue
		}

		ip4 := ipnet.IP.To4()
		if ip4 == nil {
			continue
		}

		fmt.Printf("  -> %s%s:%d\n", protocol, ip4.String(), port)
	}
}

// checkDependencies look for an executable in path, returns joined errors for not found dependencies.
func checkDependencies(deps []string) error {
	var errs []error
	for _, dep := range deps {
		if _, err := exec.LookPath(dep); err != nil {
			errs = append(errs, fmt.Errorf("'%s' is not installed or not in PATH\n", dep))
		}
	}

	if len(errs) != 0 {
		return errors.Join(errs...)
	}

	return nil
}
