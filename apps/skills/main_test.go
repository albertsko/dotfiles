package main

import (
	"errors"
	"io/fs"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

func TestFindSkills(t *testing.T) {
	root := t.TempDir()
	for _, path := range []string{
		"alpha/SKILL.md",
		"alpha/nested/SKILL.md",
		"group/beta/SKILL.md",
		".hidden/ignored/SKILL.md",
	} {
		writeTestFile(t, filepath.Join(root, path))
	}
	makeTestDir(t, filepath.Join(root, "not-a-skill", "SKILL.md"))
	makeTestLink(t, filepath.Join(root, "alpha"), filepath.Join(root, "linked-skill"))

	got, err := findSkills(root, "local")
	if err != nil {
		t.Fatal(err)
	}
	want := []skill{
		{linkName: "local-alpha", sourceDir: filepath.Join(root, "alpha"), label: "local:alpha"},
		{linkName: "local-beta", sourceDir: filepath.Join(root, "group", "beta"), label: "local:beta"},
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("findSkills() = %#v, want %#v", got, want)
	}
}

func TestFindSkillsMissingRoot(t *testing.T) {
	skills, err := findSkills(filepath.Join(t.TempDir(), "missing"), "local")
	if err != nil || len(skills) != 0 {
		t.Fatalf("findSkills() = %v, %v; want no skills and no error", skills, err)
	}
}

func TestLoadSkills(t *testing.T) {
	a := &app{repoRoot: filepath.Join(t.TempDir(), "repo"), cacheDir: t.TempDir()}
	localRoot := filepath.Join(a.repoRoot, "agents", "skills")
	writeTestFile(t, filepath.Join(localRoot, "zeta", "SKILL.md"))
	writeTestFile(t, filepath.Join(localRoot, "alpha", "SKILL.md"))
	remoteDir := filepath.Join(a.cacheDir, "superpowers", "skills", "alpha")
	writeTestFile(t, filepath.Join(remoteDir, "SKILL.md"))

	got, err := a.loadSkills()
	if err != nil {
		t.Fatal(err)
	}
	want := []skill{
		{linkName: "local-alpha", sourceDir: filepath.Join(localRoot, "alpha"), label: "local:alpha"},
		{linkName: "local-zeta", sourceDir: filepath.Join(localRoot, "zeta"), label: "local:zeta"},
		{linkName: "superpowers-alpha", sourceDir: remoteDir, label: "superpowers:alpha"},
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("loadSkills() = %#v, want %#v", got, want)
	}
}

func TestLoadSkillsRejectsDuplicateNames(t *testing.T) {
	a := &app{repoRoot: t.TempDir(), cacheDir: t.TempDir()}
	root := filepath.Join(a.repoRoot, "agents", "skills")
	writeTestFile(t, filepath.Join(root, "one", "duplicate", "SKILL.md"))
	writeTestFile(t, filepath.Join(root, "two", "duplicate", "SKILL.md"))

	_, err := a.loadSkills()
	if err == nil || !strings.Contains(err.Error(), "local-duplicate") {
		t.Fatalf("loadSkills() error = %v, want duplicate skill error", err)
	}
}

func TestReadLinks(t *testing.T) {
	root := t.TempDir()
	dir := filepath.Join(root, "links")
	makeTestDir(t, dir)
	makeTestLink(t, "../missing/./skill", filepath.Join(dir, "relative"))
	makeTestLink(t, root+"/missing/../absolute", filepath.Join(dir, "absolute"))
	writeTestFile(t, filepath.Join(dir, "regular-file"))
	makeTestDir(t, filepath.Join(dir, "directory"))

	got, err := readLinks(dir)
	if err != nil {
		t.Fatal(err)
	}
	want := map[string]string{
		"relative": filepath.Join(root, "missing", "skill"),
		"absolute": filepath.Join(root, "absolute"),
	}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("readLinks() = %v, want %v", got, want)
	}
}

func TestReadLinksDirectoryHandling(t *testing.T) {
	root := t.TempDir()
	writeTestFile(t, filepath.Join(root, "file"))
	makeTestLink(t, root, filepath.Join(root, "symlink"))
	for _, name := range []string{"missing", "file", "symlink"} {
		t.Run(name, func(t *testing.T) {
			links, err := readLinks(filepath.Join(root, name))
			if name == "missing" {
				if err != nil || len(links) != 0 {
					t.Fatalf("readLinks() = %v, %v; want no links and no error", links, err)
				}
				return
			}
			if err == nil {
				t.Fatal("readLinks() succeeded for a path that is not a real directory")
			}
		})
	}
}

func TestReplaceLinks(t *testing.T) {
	root := t.TempDir()
	a := &app{
		repoRoot: filepath.Join(root, "repo"),
		cacheDir: filepath.Join(root, "cache"),
		targets:  []string{filepath.Join(root, "agents"), filepath.Join(root, "claude"), filepath.Join(root, "codex")},
	}
	selected := []skill{
		{linkName: "local-selected", sourceDir: filepath.Join(a.repoRoot, "agents", "skills", "selected")},
		{linkName: "remote-selected", sourceDir: filepath.Join(a.cacheDir, "remote", "skills", "selected")},
	}
	for _, skill := range selected {
		writeTestFile(t, filepath.Join(skill.sourceDir, "SKILL.md"))
	}
	for _, dir := range a.targets[:2] {
		makeTestDir(t, dir)
		makeTestLink(t, "../repo/old", filepath.Join(dir, "old-local"))
		makeTestLink(t, filepath.Join(a.cacheDir, "old"), filepath.Join(dir, "old-remote"))
		makeTestLink(t, "../repo-other/skill", filepath.Join(dir, "unrelated"))
		writeTestFile(t, filepath.Join(dir, "notes"))
		makeTestDir(t, filepath.Join(dir, "manual-skill"))
	}

	if err := a.replaceLinks(selected); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		for _, old := range []string{"old-local", "old-remote"} {
			if _, err := os.Lstat(filepath.Join(dir, old)); !errors.Is(err, fs.ErrNotExist) {
				t.Fatalf("old link %s remains: %v", filepath.Join(dir, old), err)
			}
		}
		for _, selected := range selected {
			link := filepath.Join(dir, selected.linkName)
			target, err := os.Readlink(link)
			if err != nil {
				t.Fatal(err)
			}
			if filepath.IsAbs(target) || filepath.Join(dir, target) != selected.sourceDir {
				t.Fatalf("link %s targets %q, want a relative link to %s", link, target, selected.sourceDir)
			}
		}
	}

	if err := a.replaceLinks(nil); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		for _, selected := range selected {
			if _, err := os.Lstat(filepath.Join(dir, selected.linkName)); !errors.Is(err, fs.ErrNotExist) {
				t.Fatalf("empty selection did not remove %s: %v", selected.linkName, err)
			}
		}
	}
	for _, dir := range a.targets[:2] {
		target, err := os.Readlink(filepath.Join(dir, "unrelated"))
		if err != nil || target != "../repo-other/skill" {
			t.Fatalf("unrelated link changed: target %q, error %v", target, err)
		}
		contents, err := os.ReadFile(filepath.Join(dir, "notes"))
		if err != nil || string(contents) != "fixture\n" {
			t.Fatalf("regular file changed: contents %q, error %v", contents, err)
		}
		info, err := os.Lstat(filepath.Join(dir, "manual-skill"))
		if err != nil || !info.IsDir() {
			t.Fatalf("manual skill directory changed: %v", err)
		}
	}
}

func TestReplaceLinksRemovesAcrossTargetsBeforeCreating(t *testing.T) {
	root := t.TempDir()
	a := &app{
		repoRoot: filepath.Join(root, "repo"),
		cacheDir: filepath.Join(root, "cache"),
		targets:  []string{filepath.Join(root, "first"), filepath.Join(root, "not-a-directory")},
	}
	makeTestDir(t, a.targets[0])
	makeTestLink(t, "../repo/old", filepath.Join(a.targets[0], "old"))
	writeTestFile(t, a.targets[1])
	selected := []skill{{linkName: "local-new", sourceDir: filepath.Join(a.repoRoot, "new")}}

	if err := a.replaceLinks(selected); err == nil {
		t.Fatal("replaceLinks() succeeded with an invalid target directory")
	}
	for _, name := range []string{"old", "local-new"} {
		if _, err := os.Lstat(filepath.Join(a.targets[0], name)); !errors.Is(err, fs.ErrNotExist) {
			t.Fatalf("link %q exists after removal failed on a later target: %v", name, err)
		}
	}
}

func makeTestDir(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(path, 0o755); err != nil {
		t.Fatal(err)
	}
}

func writeTestFile(t *testing.T, path string) {
	t.Helper()
	makeTestDir(t, filepath.Dir(path))
	if err := os.WriteFile(path, []byte("fixture\n"), 0o644); err != nil {
		t.Fatal(err)
	}
}

func makeTestLink(t *testing.T, target, path string) {
	t.Helper()
	if err := os.Symlink(target, path); err != nil {
		t.Fatal(err)
	}
}
