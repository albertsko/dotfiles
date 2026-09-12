package main

import (
	"errors"
	"io/fs"
	"net/url"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"
)

func TestNewApp(t *testing.T) {
	a := testApp(t)
	if a.repoRoot != os.Getenv("DOTFILES_HOME") {
		t.Fatalf("repoRoot = %q", a.repoRoot)
	}
	wantCache := filepath.Join(os.Getenv("XDG_DATA_HOME"), "albertsko-skills")
	if a.cacheDir != wantCache {
		t.Fatalf("cacheDir = %q, want %q", a.cacheDir, wantCache)
	}
	wantTargets := []string{
		filepath.Join(os.Getenv("HOME"), ".agents", "skills"),
		filepath.Join(os.Getenv("HOME"), ".claude", "skills"),
		filepath.Join(os.Getenv("HOME"), ".codex", "skills"),
	}
	if !reflect.DeepEqual(a.targets, wantTargets) {
		t.Fatalf("targets = %v, want %v", a.targets, wantTargets)
	}

	t.Setenv("XDG_DATA_HOME", "")
	a, err := newApp()
	if err != nil {
		t.Fatal(err)
	}
	if want := filepath.Join(os.Getenv("HOME"), ".local", "share", "albertsko-skills"); a.cacheDir != want {
		t.Fatalf("cacheDir = %q, want %q", a.cacheDir, want)
	}

	t.Chdir(t.TempDir())
	t.Setenv("DOTFILES_HOME", "dotfiles")
	t.Setenv("XDG_DATA_HOME", "data")
	a, err = newApp()
	if err != nil {
		t.Fatal(err)
	}
	if !filepath.IsAbs(a.repoRoot) || !filepath.IsAbs(a.cacheDir) {
		t.Fatalf("paths were not made absolute: %+v", a)
	}

	t.Setenv("DOTFILES_HOME", "")
	if _, err := newApp(); err == nil {
		t.Fatal("missing DOTFILES_HOME was accepted")
	}
}

func TestSymlinkedHomeCreatesWorkingRelativeLinks(t *testing.T) {
	a := testApp(t)
	wanted := makeSkill(t, "local", filepath.Join(a.repoRoot, "agents", "skills", "wanted"))
	homeAlias := filepath.Join(t.TempDir(), "home-alias")
	symlink(t, os.Getenv("HOME"), homeAlias)
	t.Setenv("HOME", homeAlias)
	a, err := newApp()
	if err != nil {
		t.Fatal(err)
	}
	if err := a.replaceLinks([]skill{wanted}); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		assertRelativeLinks(t, dir, []skill{wanted})
		assertContent(t, filepath.Join(dir, wanted.name, "SKILL.md"), "# skill\n")
	}
}

func TestArgumentsAreRejected(t *testing.T) {
	for _, arg := range []string{"--update", "-update", "--unknown"} {
		if err := run([]string{arg}); err == nil || !strings.Contains(err.Error(), "unexpected argument") {
			t.Fatalf("run(%q) = %v, want argument error", arg, err)
		}
	}
}

func TestDiscovery(t *testing.T) {
	a := testApp(t)
	root := filepath.Join(a.repoRoot, "agents", "skills")
	makeSkill(t, "local", filepath.Join(root, "top"))
	makeSkill(t, "local", filepath.Join(root, "group", "deep"))
	makeSkill(t, "local", filepath.Join(root, "top", "references", "nested"))
	makeSkill(t, "local", filepath.Join(root, ".hidden", "ignored"))
	makeSkill(t, "mattpocock", filepath.Join(a.cacheDir, "mattpocock", "skills", "engineering", "remote"))
	makeSkill(t, "addyosmani", filepath.Join(a.cacheDir, "addyosmani", "skills", "extra"))
	makeSkill(t, "superpowers", filepath.Join(a.cacheDir, "superpowers", "skills", "super"))
	mkdir(t, filepath.Join(root, "invalid", "SKILL.md"))

	skills, err := a.loadSkills()
	if err != nil {
		t.Fatal(err)
	}
	var labels []string
	for _, skill := range skills {
		labels = append(labels, skill.label)
	}
	want := []string{"addyosmani:extra", "local:deep", "local:top", "mattpocock:remote", "superpowers:super"}
	if !reflect.DeepEqual(labels, want) {
		t.Fatalf("skills = %v, want %v", labels, want)
	}
	if skills, err := findSkills(filepath.Join(root, "missing"), "local"); err != nil || len(skills) != 0 {
		t.Fatalf("missing source: %v, %v", skills, err)
	}
}

func TestSkillNamesAreUniquePerSource(t *testing.T) {
	a := testApp(t)
	root := filepath.Join(a.repoRoot, "agents", "skills")
	makeSkill(t, "local", filepath.Join(root, "output"))
	makeSkill(t, "local", filepath.Join(root, "group", "output"))
	if _, err := a.loadSkills(); err == nil || !strings.Contains(err.Error(), "duplicate skill") {
		t.Fatalf("duplicate within source: %v", err)
	}
	if err := os.RemoveAll(filepath.Join(root, "group")); err != nil {
		t.Fatal(err)
	}
	makeSkill(t, "mattpocock", filepath.Join(a.cacheDir, "mattpocock", "skills", "output"))
	skills, err := a.loadSkills()
	if err != nil {
		t.Fatal(err)
	}
	var names []string
	for _, skill := range skills {
		names = append(names, skill.name)
	}
	if want := []string{"local-output", "mattpocock-output"}; !reflect.DeepEqual(names, want) {
		t.Fatalf("names = %v, want %v", names, want)
	}
	if err := a.replaceLinks(skills); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		assertRelativeLinks(t, dir, skills)
	}
}

func TestPreselectionUsesFirstTargetDestinations(t *testing.T) {
	t.Setenv("TERM", "dumb")
	inputPath := filepath.Join(t.TempDir(), "input")
	writeFile(t, inputPath, "0\n")
	input, err := os.Open(inputPath)
	if err != nil {
		t.Fatal(err)
	}
	previousStdin := os.Stdin
	os.Stdin = input
	t.Cleanup(func() {
		os.Stdin = previousStdin
		input.Close()
	})

	a := testApp(t)
	root := filepath.Join(a.repoRoot, "agents", "skills")
	first := makeSkill(t, "local", filepath.Join(root, "first"))
	second := makeSkill(t, "local", filepath.Join(root, "second"))
	wrong := makeSkill(t, "local", filepath.Join(root, "wrong"))
	alias := makeSkill(t, "local", filepath.Join(root, "alias"))
	symlink(t, first.path, filepath.Join(a.targets[0], "first"))
	symlink(t, second.path, filepath.Join(a.targets[1], second.name))
	symlink(t, "/elsewhere", filepath.Join(a.targets[0], wrong.name))
	symlink(t, alias.path, filepath.Join(a.targets[0], "another-name"))

	links, err := readLinks(a.targets[0])
	if err != nil {
		t.Fatal(err)
	}
	selected, err := chooseSkills([]skill{first, second, wrong, alias}, links)
	if err != nil {
		t.Fatal(err)
	}
	if want := []skill{first, alias}; !reflect.DeepEqual(selected, want) {
		t.Fatalf("preselected = %v, want %v", selected, want)
	}

	links, err = readLinks(filepath.Join(t.TempDir(), "missing"))
	if err != nil || len(links) != 0 {
		t.Fatalf("missing target: %v, %v", links, err)
	}
	if _, err := input.Seek(0, 0); err != nil {
		t.Fatal(err)
	}
	selected, err = chooseSkills([]skill{first, second}, links)
	if err != nil || len(selected) != 0 {
		t.Fatalf("missing target preselected %v, %v", selected, err)
	}
}

func TestReplaceLinksRebuildsAndPreservesUnmanagedEntries(t *testing.T) {
	a := testApp(t)
	local := makeSkill(t, "local", filepath.Join(a.repoRoot, "agents", "skills", "local"))
	remote := makeSkill(t, "mattpocock", filepath.Join(a.cacheDir, "mattpocock", "skills", "remote"))
	selected := []skill{local, remote}
	for _, dir := range a.targets {
		symlink(t, local.path, filepath.Join(dir, local.name))
		symlink(t, local.path, filepath.Join(dir, "local"))
		symlink(t, filepath.Join(a.repoRoot, "old-location", "gone"), filepath.Join(dir, "stale"))
		symlink(t, a.repoRoot, filepath.Join(dir, "repo-root"))
		symlink(t, filepath.Join(a.cacheDir, "old-source", "gone"), filepath.Join(dir, ".hidden-link"))
		relative, err := filepath.Rel(dir, filepath.Join(a.repoRoot, "missing"))
		if err != nil {
			t.Fatal(err)
		}
		symlink(t, relative, filepath.Join(dir, "relative-stale"))
		symlink(t, a.repoRoot+"-backup/skill", filepath.Join(dir, "outside-repo"))
		symlink(t, a.cacheDir+"-backup/skill", filepath.Join(dir, "outside-cache"))
		writeFile(t, filepath.Join(dir, ".system", "SKILL.md"), "system")
		writeFile(t, filepath.Join(dir, "copied", "SKILL.md"), "copied")
		writeFile(t, filepath.Join(dir, "file"), "keep")
	}
	if err := a.replaceLinks(selected); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		assertRelativeLinks(t, dir, selected)
		assertMissing(t, filepath.Join(dir, "local"))
		assertMissing(t, filepath.Join(dir, "stale"))
		assertMissing(t, filepath.Join(dir, "repo-root"))
		assertMissing(t, filepath.Join(dir, ".hidden-link"))
		assertMissing(t, filepath.Join(dir, "relative-stale"))
		assertContent(t, filepath.Join(dir, ".system", "SKILL.md"), "system")
		assertContent(t, filepath.Join(dir, "copied", "SKILL.md"), "copied")
		assertContent(t, filepath.Join(dir, "file"), "keep")
		if got, err := os.Readlink(filepath.Join(dir, "outside-repo")); err != nil || got != a.repoRoot+"-backup/skill" {
			t.Fatalf("unmanaged repo link changed: %q, %v", got, err)
		}
		if got, err := os.Readlink(filepath.Join(dir, "outside-cache")); err != nil || got != a.cacheDir+"-backup/skill" {
			t.Fatalf("unmanaged cache link changed: %q, %v", got, err)
		}
	}

	if err := a.replaceLinks(nil); err != nil {
		t.Fatal(err)
	}
	for _, dir := range a.targets {
		assertMissing(t, filepath.Join(dir, local.name))
		assertMissing(t, filepath.Join(dir, remote.name))
		assertContent(t, filepath.Join(dir, ".system", "SKILL.md"), "system")
	}
}

func TestUnmanagedConflictFailsAfterCleanup(t *testing.T) {
	a := testApp(t)
	wanted := makeSkill(t, "local", filepath.Join(a.repoRoot, "agents", "skills", "wanted"))
	for _, dir := range a.targets {
		symlink(t, filepath.Join(a.cacheDir, "gone"), filepath.Join(dir, "stale"))
	}
	conflict := filepath.Join(a.targets[1], wanted.name)
	writeFile(t, conflict, "keep")
	if err := a.replaceLinks([]skill{wanted}); !errors.Is(err, fs.ErrExist) {
		t.Fatalf("replaceLinks() = %v, want existing entry error", err)
	}
	for _, dir := range a.targets {
		assertMissing(t, filepath.Join(dir, "stale"))
	}
	assertContent(t, conflict, "keep")
	assertRelativeLinks(t, a.targets[0], []skill{wanted})
	assertMissing(t, filepath.Join(a.targets[2], wanted.name))
}

func TestSymlinkedTargetIsRejected(t *testing.T) {
	a := testApp(t)
	outside := t.TempDir()
	symlink(t, a.repoRoot, filepath.Join(outside, "keep"))
	symlink(t, outside, a.targets[0])
	if err := a.replaceLinks(nil); err == nil || !strings.Contains(err.Error(), "not a real directory") {
		t.Fatalf("replaceLinks() = %v, want real directory error", err)
	}
	if _, err := os.Readlink(filepath.Join(outside, "keep")); err != nil {
		t.Fatal(err)
	}
}

func TestOwnershipBoundaries(t *testing.T) {
	root := filepath.Join(t.TempDir(), "dotfiles")
	cases := map[string]bool{
		root:                               true,
		filepath.Join(root, "missing"):     true,
		filepath.Join(root, ".hidden"):     true,
		root + "-backup/skill":             false,
		filepath.Dir(root):                 false,
		filepath.Join(root, "..", "other"): false,
	}
	for path, want := range cases {
		if got := withinRoot(root, path); got != want {
			t.Fatalf("withinRoot(%q, %q) = %t, want %t", root, path, got, want)
		}
	}
}

func TestRepositoryAlwaysRefreshes(t *testing.T) {
	a := testApp(t)
	origin := localRepository(t)
	sourceURL := (&url.URL{Scheme: "file", Path: origin}).String()
	for name := range remotes {
		dir := filepath.Join(a.cacheDir, name)
		if err := syncRepository(sourceURL, dir); err != nil {
			t.Fatal(err)
		}
		cachedSkill := filepath.Join(dir, "skills", "example", "SKILL.md")
		assertContent(t, cachedSkill, "initial")
		if _, err := os.Stat(filepath.Join(dir, ".git", "shallow")); err != nil {
			t.Fatalf("clone is not shallow: %v", err)
		}
		writeFile(t, cachedSkill, "local edit")
	}
	writeFile(t, filepath.Join(origin, "skills", "example", "SKILL.md"), "updated")
	commit(t, origin)
	if err := a.syncRepositories(); err != nil {
		t.Fatal(err)
	}
	for name := range remotes {
		assertContent(t, filepath.Join(a.cacheDir, name, "skills", "example", "SKILL.md"), "updated")
	}
}

func TestRefreshFailuresStopBeforeChangingLinks(t *testing.T) {
	for _, failure := range []string{"fetch", "reset"} {
		t.Run(failure, func(t *testing.T) {
			a := testApp(t)
			origin := localRepository(t)
			cloneTestRemotes(t, a, origin)
			dir := filepath.Join(a.cacheDir, "mattpocock")
			wanted := makeSkill(t, "local", filepath.Join(a.repoRoot, "agents", "skills", "wanted"))
			link := filepath.Join(a.targets[0], wanted.name)
			symlink(t, wanted.path, link)
			if failure == "fetch" {
				runGit(t, "-C", dir, "remote", "set-url", "origin", filepath.Join(t.TempDir(), "missing"))
			}
			if failure == "reset" {
				writeFile(t, filepath.Join(dir, ".git", "index.lock"), "locked")
			}
			if err := a.run(); err == nil || !strings.Contains(err.Error(), failure) {
				t.Fatalf("run() = %v, want %s error", err, failure)
			}
			if got, err := os.Readlink(link); err != nil || got != wanted.path {
				t.Fatalf("existing link changed: %q, %v", got, err)
			}
			assertMissing(t, a.targets[1])
		})
	}
}

func TestCloneFailure(t *testing.T) {
	root := t.TempDir()
	if err := syncRepository(filepath.Join(root, "missing"), filepath.Join(root, "cache", "clone")); err == nil {
		t.Fatal("missing repository was accepted")
	}
}

// --- helpers ---

func testApp(t *testing.T) *app {
	t.Helper()
	root, err := filepath.EvalSymlinks(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Setenv("HOME", filepath.Join(root, "home"))
	mkdir(t, os.Getenv("HOME"))
	t.Setenv("DOTFILES_HOME", filepath.Join(root, "dotfiles"))
	t.Setenv("XDG_DATA_HOME", filepath.Join(root, "data"))
	a, err := newApp()
	if err != nil {
		t.Fatal(err)
	}
	return a
}

func mkdir(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(path, 0o755); err != nil {
		t.Fatal(err)
	}
}

func writeFile(t *testing.T, path, content string) {
	t.Helper()
	mkdir(t, filepath.Dir(path))
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}
}

func makeSkill(t *testing.T, source, path string) skill {
	t.Helper()
	writeFile(t, filepath.Join(path, "SKILL.md"), "# skill\n")
	return skill{name: source + "-" + filepath.Base(path), path: path, label: source + ":" + filepath.Base(path)}
}

func symlink(t *testing.T, target, path string) {
	t.Helper()
	mkdir(t, filepath.Dir(path))
	if err := os.Symlink(target, path); err != nil {
		t.Fatal(err)
	}
}

func assertMissing(t *testing.T, path string) {
	t.Helper()
	if _, err := os.Lstat(path); !errors.Is(err, fs.ErrNotExist) {
		t.Fatalf("%s: got %v, want missing entry", path, err)
	}
}

func assertContent(t *testing.T, path, want string) {
	t.Helper()
	got, err := os.ReadFile(path)
	if err != nil || string(got) != want {
		t.Fatalf("%s: got %q, %v; want %q", path, got, err, want)
	}
}

func assertRelativeLinks(t *testing.T, dir string, skills []skill) {
	t.Helper()
	for _, skill := range skills {
		path := filepath.Join(dir, skill.name)
		target, err := resolveLink(path)
		if err != nil || target != skill.path {
			t.Fatalf("%s: got %q, %v; want %q", path, target, err, skill.path)
		}
		raw, err := os.Readlink(path)
		if err != nil || filepath.IsAbs(raw) {
			t.Fatalf("%s: got %q, %v; want relative link", path, raw, err)
		}
	}
}

func runGit(t *testing.T, args ...string) {
	t.Helper()
	if err := git(args...); err != nil {
		t.Fatal(err)
	}
}

func commit(t *testing.T, dir string) {
	t.Helper()
	runGit(t, "-C", dir, "add", ".")
	runGit(t, "-C", dir, "-c", "user.name=Skills Test", "-c", "user.email=skills@example.invalid",
		"-c", "commit.gpgsign=false", "commit", "--quiet", "-m", "fixture")
}

func localRepository(t *testing.T) string {
	t.Helper()
	t.Setenv("GIT_CONFIG_NOSYSTEM", "1")
	t.Setenv("GIT_CONFIG_GLOBAL", os.DevNull)
	dir := t.TempDir()
	runGit(t, "-C", dir, "init", "--quiet")
	writeFile(t, filepath.Join(dir, "skills", "example", "SKILL.md"), "initial")
	commit(t, dir)
	return dir
}

func cloneTestRemotes(t *testing.T, a *app, origin string) {
	t.Helper()
	for name := range remotes {
		if err := syncRepository(origin, filepath.Join(a.cacheDir, name)); err != nil {
			t.Fatal(err)
		}
	}
}
