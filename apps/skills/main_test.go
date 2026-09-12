package main

import (
	"bytes"
	"context"
	"errors"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"
)

type world struct {
	t       *testing.T
	app     app
	options options
	log     *bytes.Buffer
	git     [][]string
	fail    map[string]error
}

func newWorld(t *testing.T) *world {
	t.Helper()

	root := t.TempDir()
	cache := filepath.Join(root, "cache")
	remote := filepath.Join(cache, remoteName)
	mkdir(t, remote)

	w := &world{t: t, log: &bytes.Buffer{}, fail: map[string]error{}}
	w.app = app{
		spec: defaultSpec,
		paths: appPaths{
			homeDir:  filepath.Join(root, "targets"),
			repoRoot: root,
			cacheDir: cache,
		},
		stderr:  w.log,
		symlink: os.Symlink,
	}
	w.app.git = func(ctx context.Context, args ...string) error {
		w.git = append(w.git, args)
		for pattern, err := range w.fail {
			if strings.Contains(strings.Join(args, " "), pattern) {
				return err
			}
		}
		if args[0] == "clone" {
			mkdir(t, args[len(args)-1])
		}
		return nil
	}
	w.app.choose = func(skills []skill, selected []string) ([]string, error) {
		return nil, nil
	}
	return w
}

func (w *world) local(name string) string {
	w.t.Helper()
	return skillDir(w.t, filepath.Join(w.app.paths.repoRoot, "agents", "skills", name))
}

func (w *world) remote(name string) string {
	w.t.Helper()
	return skillDir(w.t, filepath.Join(w.app.paths.cacheDir, remoteName, "skills", name))
}

func (w *world) run(labels ...string) error {
	w.t.Helper()
	w.app.choose = func(skills []skill, selected []string) ([]string, error) {
		return labels, nil
	}
	return w.app.run(context.Background(), w.options)
}

func (w *world) assertLinks(want ...string) {
	w.t.Helper()
	sort.Strings(want)
	for _, dir := range w.app.targetDirs() {
		entries, err := os.ReadDir(dir)
		if err != nil {
			w.t.Fatal(err)
		}
		var got []string
		for _, entry := range entries {
			got = append(got, entry.Name())
		}
		sort.Strings(got)
		if strings.Join(got, ",") != strings.Join(want, ",") {
			w.t.Fatalf("links in %s = %v, want %v", dir, got, want)
		}
	}
}

func (w *world) gitRan(part string) bool {
	for _, args := range w.git {
		if strings.Contains(strings.Join(args, " "), part) {
			return true
		}
	}
	return false
}

func mkdir(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(path, 0o755); err != nil {
		t.Fatal(err)
	}
}

func skillDir(t *testing.T, path string) string {
	t.Helper()
	mkdir(t, path)
	if err := os.WriteFile(filepath.Join(path, "SKILL.md"), []byte("# skill\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	return path
}

func TestParseOptions(t *testing.T) {
	tests := []struct {
		name       string
		args       []string
		wantUpdate bool
		wantError  bool
	}{
		{name: "default"},
		{name: "short update", args: []string{"-update"}, wantUpdate: true},
		{name: "long update", args: []string{"--update"}, wantUpdate: true},
		{name: "unexpected", args: []string{"--unknown"}, wantError: true},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got, err := parseOptions(test.args)
			if (err != nil) != test.wantError {
				t.Fatalf("parseOptions() error = %v, want error %t", err, test.wantError)
			}
			if got.update != test.wantUpdate {
				t.Fatalf("parseOptions().update = %t, want %t", got.update, test.wantUpdate)
			}
		})
	}
}

func TestDiscoveryAndSelection(t *testing.T) {
	w := newWorld(t)
	w.local("top")
	skillDir(t, filepath.Join(w.app.paths.repoRoot, "agents", "skills", "group", "deep"))
	w.remote("remote")

	if err := w.run("local:top", "local:deep", remoteName+":remote"); err != nil {
		t.Fatal(err)
	}
	w.assertLinks("top", "deep", "remote")
}

func TestDiscoverySkipsHiddenAndNestedSkills(t *testing.T) {
	w := newWorld(t)
	outer := w.local("outer")
	skillDir(t, filepath.Join(outer, "references", "inner"))
	skillDir(t, filepath.Join(w.app.paths.repoRoot, "agents", "skills", ".hidden"))

	if err := w.run("local:outer"); err != nil {
		t.Fatal(err)
	}
	w.assertLinks("outer")
	if err := w.run("local:inner"); err == nil {
		t.Fatal("nested skill was discovered")
	}
}

func TestDuplicateSkillNamesAreRejected(t *testing.T) {
	w := newWorld(t)
	w.local("output")
	w.remote("output")
	if err := w.run(); err == nil || !strings.Contains(err.Error(), "output") {
		t.Fatalf("err = %v, want duplicate output error", err)
	}
}

func TestRemoteCloneAndUpdate(t *testing.T) {
	t.Run("clone", func(t *testing.T) {
		w := newWorld(t)
		if err := os.RemoveAll(filepath.Join(w.app.paths.cacheDir, remoteName)); err != nil {
			t.Fatal(err)
		}
		if err := w.run(); err != nil {
			t.Fatal(err)
		}
		if !w.gitRan("clone --depth 1") {
			t.Fatalf("git calls = %v, want shallow clone", w.git)
		}
	})

	t.Run("update", func(t *testing.T) {
		w := newWorld(t)
		w.options.update = true
		if err := w.run(); err != nil {
			t.Fatal(err)
		}
		if !w.gitRan("fetch --depth 1 origin") || !w.gitRan("reset --hard FETCH_HEAD") {
			t.Fatalf("git calls = %v, want fetch and reset", w.git)
		}
	})

	t.Run("failed update uses cache", func(t *testing.T) {
		w := newWorld(t)
		w.options.update = true
		w.fail["fetch"] = errors.New("offline")
		if err := w.run(); err != nil {
			t.Fatal(err)
		}
		if !strings.Contains(w.log.String(), "Warning") {
			t.Fatalf("log = %q, want warning", w.log.String())
		}
	})
}

func TestLinksAreRelativeAndPreselected(t *testing.T) {
	w := newWorld(t)
	w.local("local")
	w.remote("remote")
	if err := w.run("local:local", remoteName+":remote"); err != nil {
		t.Fatal(err)
	}

	for _, dir := range w.app.targetDirs() {
		for _, name := range []string{"local", "remote"} {
			target, err := os.Readlink(filepath.Join(dir, name))
			if err != nil {
				t.Fatal(err)
			}
			if filepath.IsAbs(target) {
				t.Fatalf("link target %q is absolute", target)
			}
		}
	}

	var got []string
	w.app.choose = func(skills []skill, selected []string) ([]string, error) {
		got = selected
		return nil, errCancelled
	}
	if err := w.app.run(context.Background(), w.options); err != nil {
		t.Fatal(err)
	}
	sort.Strings(got)
	want := []string{"local:local", remoteName + ":remote"}
	sort.Strings(want)
	if strings.Join(got, ",") != strings.Join(want, ",") {
		t.Fatalf("preselected = %v, want %v", got, want)
	}
}

func TestSyncPreservesUnmanagedEntries(t *testing.T) {
	w := newWorld(t)
	w.local("wanted")
	w.local("unwanted")
	if err := w.run("local:wanted", "local:unwanted"); err != nil {
		t.Fatal(err)
	}

	for _, dir := range w.app.targetDirs() {
		mkdir(t, filepath.Join(dir, ".system"))
		mkdir(t, filepath.Join(dir, "copied"))
		if err := os.Symlink("/nowhere", filepath.Join(dir, "unmanaged")); err != nil {
			t.Fatal(err)
		}
	}
	if err := w.run("local:wanted"); err != nil {
		t.Fatal(err)
	}

	for _, dir := range w.app.targetDirs() {
		if _, err := os.Lstat(filepath.Join(dir, "unwanted")); !errors.Is(err, fs.ErrNotExist) {
			t.Fatalf("unwanted link still exists: %v", err)
		}
		for _, name := range []string{"wanted", ".system", "copied", "unmanaged"} {
			if _, err := os.Lstat(filepath.Join(dir, name)); err != nil {
				t.Fatalf("entry %q was removed: %v", name, err)
			}
		}
	}
}

func TestUnmanagedConflictStopsBeforeChanges(t *testing.T) {
	tests := map[string]func(*testing.T, string){
		"directory": func(t *testing.T, path string) {
			mkdir(t, path)
		},
		"symlink": func(t *testing.T, path string) {
			if err := os.Symlink("/unmanaged", path); err != nil {
				t.Fatal(err)
			}
		},
	}

	for name, makeConflict := range tests {
		t.Run(name, func(t *testing.T) {
			w := newWorld(t)
			w.local("wanted")
			targetDirs := w.app.targetDirs()
			mkdir(t, targetDirs[0])
			makeConflict(t, filepath.Join(targetDirs[0], "wanted"))

			err := w.run("local:wanted")
			if err == nil || !strings.Contains(err.Error(), "unmanaged entry") {
				t.Fatalf("err = %v, want unmanaged conflict", err)
			}
			if _, err := os.Stat(targetDirs[1]); !errors.Is(err, fs.ErrNotExist) {
				t.Fatalf("another target was changed: %v", err)
			}
		})
	}
}

func TestSymlinkedTargetIsRejected(t *testing.T) {
	w := newWorld(t)
	w.local("wanted")
	outside := filepath.Join(w.app.paths.repoRoot, "outside")
	mkdir(t, outside)
	targetDir := w.app.targetDirs()[0]
	mkdir(t, filepath.Dir(targetDir))
	if err := os.Symlink(outside, targetDir); err != nil {
		t.Fatal(err)
	}

	if err := w.run("local:wanted"); err == nil || !strings.Contains(err.Error(), "is a symlink") {
		t.Fatalf("err = %v, want symlink error", err)
	}
}

func TestStagingFailurePreservesExistingLinks(t *testing.T) {
	w := newWorld(t)
	w.local("wanted")
	w.local("unwanted")
	if err := w.run("local:wanted", "local:unwanted"); err != nil {
		t.Fatal(err)
	}

	calls := 0
	w.app.symlink = func(oldname, newname string) error {
		calls++
		if calls == 2 {
			return errors.New("filesystem full")
		}
		return os.Symlink(oldname, newname)
	}
	if err := w.run("local:wanted"); err == nil || !strings.Contains(err.Error(), "filesystem full") {
		t.Fatalf("err = %v, want staging error", err)
	}
	w.assertLinks("wanted", "unwanted")
}

func TestCancellationChangesNothing(t *testing.T) {
	w := newWorld(t)
	w.local("wanted")
	w.app.choose = func(skills []skill, selected []string) ([]string, error) {
		return nil, errCancelled
	}
	if err := w.app.run(context.Background(), w.options); err != nil {
		t.Fatal(err)
	}
	for _, dir := range w.app.targetDirs() {
		if _, err := os.Stat(dir); !errors.Is(err, fs.ErrNotExist) {
			t.Fatalf("cancelled run created %s", dir)
		}
	}
}

func TestCanonicalPathResolvesMissingSymlinkedPrefix(t *testing.T) {
	root := t.TempDir()
	realRoot := filepath.Join(root, "real")
	mkdir(t, realRoot)
	alias := filepath.Join(root, "alias")
	if err := os.Symlink(realRoot, alias); err != nil {
		t.Fatal(err)
	}

	got, err := canonicalPath(filepath.Join(alias, "missing", "path"))
	if err != nil {
		t.Fatal(err)
	}
	want, err := canonicalPath(filepath.Join(realRoot, "missing", "path"))
	if err != nil {
		t.Fatal(err)
	}
	if got != want {
		t.Fatalf("canonicalPath = %q, want %q", got, want)
	}
}
