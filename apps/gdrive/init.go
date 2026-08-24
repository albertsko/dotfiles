package main

import (
	"errors"
	"log"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

const (
	RcloneGeMajorVersion = 1
	RcloneGeMinorVersion = 75
)

func init() {
	checkRclone()
}

func checkRclone() {
	_, err := exec.LookPath("rclone")
	if errors.Is(err, exec.ErrNotFound) {
		log.Fatalf("failed to find rclone in PATH")
	}
	if err != nil {
		log.Fatalf("failed to check rclone %+v", err)
	}

	cmd := exec.Command("rclone", "--version")
	out, _ := cmd.CombinedOutput()

	firstLine, _, _ := strings.Cut(string(out), "\n")

	checkVersion := func(versionLine string, geMajor int, geMinor int) bool {
		re := regexp.MustCompile(`^rclone v(\d+)\.(\d+)`)
		matches := re.FindStringSubmatch(versionLine)

		if len(matches) != 3 {
			return false
		}

		major, _ := strconv.Atoi(matches[1])
		minor, _ := strconv.Atoi(matches[2])

		if major < geMajor || minor < geMinor {
			return false
		}

		return true
	}

	ok := checkVersion(firstLine, RcloneGeMajorVersion, RcloneGeMinorVersion)
	if !ok {
		log.Fatalf("incorrect rclone version, must be greater or equal %d.%d", RcloneGeMajorVersion, RcloneGeMinorVersion)
	}
}
