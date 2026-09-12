package main

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"charm.land/huh/v2"
)

var remotes = map[string]string{
	"mattpocock":  "https://github.com/mattpocock/skills",
	"addyosmani":  "https://github.com/addyosmani/agent-skills",
	"superpowers": "https://github.com/obra/superpowers",
}

var targetPaths = []string{".agents/skills", ".claude/skills", ".codex/skills"}

type skill struct {
	name  string
	path  string
	label string
}

type app struct {
	repoRoot string
	cacheDir string
	targets  []string
}

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
		os.Exit(1)
	}
}

func run() error {
	a, err := newApp()
	if err != nil {
		return err
	}
	return a.run()
}

func newApp() (*app, error) {
	repoRoot := os.Getenv("DOTFILES_HOME")
	if repoRoot == "" {
		return nil, errors.New("DOTFILES_HOME is not set")
	}
	repoRoot, err := filepath.Abs(repoRoot)
	if err != nil {
		return nil, err
	}
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, err
	}
	homeDir, err = filepath.Abs(homeDir)
	if err != nil {
		return nil, err
	}
	dataHome := os.Getenv("XDG_DATA_HOME")
	if dataHome == "" {
		dataHome = filepath.Join(homeDir, ".local", "share")
	}
	cacheDir, err := filepath.Abs(filepath.Join(dataHome, "albertsko-skills"))
	if err != nil {
		return nil, err
	}
	targets := make([]string, 0, len(targetPaths))
	for _, path := range targetPaths {
		targets = append(targets, filepath.Join(homeDir, path))
	}
	return &app{repoRoot: repoRoot, cacheDir: cacheDir, targets: targets}, nil
}

func (a *app) run() error {
	if err := a.syncRepositories(); err != nil {
		return err
	}
	links, err := readLinks(a.targets[0])
	if err != nil {
		return err
	}
	skills, err := a.loadSkills()
	if err != nil {
		return err
	}
	selected, err := chooseSkills(skills, links)
	if errors.Is(err, huh.ErrUserAborted) {
		fmt.Fprintln(os.Stderr, "Skill links unchanged.")
		return nil
	}
	if err != nil {
		return err
	}
	if err := a.replaceLinks(selected); err != nil {
		return err
	}
	fmt.Fprintf(os.Stderr, "Enabled %d skill(s) across %d directories.\n", len(selected), len(a.targets))
	return nil
}

func (a *app) syncRepositories() error {
	for name, url := range remotes {
		if err := syncRepository(url, filepath.Join(a.cacheDir, name)); err != nil {
			return err
		}
	}
	return nil
}

func (a *app) replaceLinks(selected []skill) error {
	for _, dir := range a.targets {
		if err := a.removeLinks(dir); err != nil {
			return err
		}
	}
	for _, dir := range a.targets {
		if err := linkSkills(dir, selected); err != nil {
			return err
		}
	}
	return nil
}

func (a *app) removeLinks(dir string) error {
	links, err := readLinks(dir)
	if err != nil {
		return err
	}
	for name, target := range links {
		if !withinRoot(a.repoRoot, target) && !withinRoot(a.cacheDir, target) {
			continue
		}
		if err := os.Remove(filepath.Join(dir, name)); err != nil {
			return err
		}
	}
	return nil
}

func (a *app) loadSkills() ([]skill, error) {
	skills, err := findSkills(filepath.Join(a.repoRoot, "agents", "skills"), "local")
	if err != nil {
		return nil, err
	}
	for name := range remotes {
		remote, err := findSkills(filepath.Join(a.cacheDir, name, "skills"), name)
		if err != nil {
			return nil, err
		}
		skills = append(skills, remote...)
	}
	owners := make(map[string]string)
	for _, skill := range skills {
		if owner, exists := owners[skill.name]; exists {
			return nil, fmt.Errorf("duplicate skill %q in %s and %s", skill.name, owner, skill.path)
		}
		owners[skill.name] = skill.path
	}
	sort.Slice(skills, func(i, j int) bool { return skills[i].label < skills[j].label })
	return skills, nil
}

func chooseSkills(skills []skill, links map[string]string) ([]skill, error) {
	enabled := make(map[string]bool, len(links))
	for _, target := range links {
		enabled[target] = true
	}
	options := make([]huh.Option[skill], 0, len(skills))
	for _, skill := range skills {
		options = append(options, huh.NewOption(skill.label, skill).Selected(enabled[skill.path]))
	}

	var selected []skill
	field := huh.NewMultiSelect[skill]().
		Title("Select skills to enable").
		Options(options...).
		Value(&selected)
	err := huh.NewForm(huh.NewGroup(field)).Run()
	return selected, err
}

// --- helpers ---

func readLinks(dir string) (map[string]string, error) {
	info, err := os.Lstat(dir)
	if errors.Is(err, fs.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if !info.IsDir() {
		return nil, fmt.Errorf("%s is not a real directory", dir)
	}
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	links := make(map[string]string)
	for _, entry := range entries {
		if entry.Type()&fs.ModeSymlink == 0 {
			continue
		}
		target, err := resolveLink(filepath.Join(dir, entry.Name()))
		if err != nil {
			return nil, err
		}
		links[entry.Name()] = target
	}
	return links, nil
}

func resolveLink(link string) (string, error) {
	target, err := os.Readlink(link)
	if err != nil {
		return "", err
	}
	if filepath.IsAbs(target) {
		return filepath.Clean(target), nil
	}
	return filepath.Clean(filepath.Join(filepath.Dir(link), target)), nil
}

func withinRoot(root, path string) bool {
	relative, err := filepath.Rel(root, path)
	return err == nil && filepath.IsLocal(relative)
}

func git(args ...string) error {
	cmd := exec.Command("git", args...)
	cmd.Stdout = os.Stderr
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("git %s: %w", strings.Join(args, " "), err)
	}
	return nil
}

func syncRepository(url, dir string) error {
	if err := os.MkdirAll(filepath.Dir(dir), 0o755); err != nil {
		return err
	}
	_, err := os.Stat(dir)
	if errors.Is(err, fs.ErrNotExist) {
		return git("clone", "--depth", "1", url, dir)
	}
	if err != nil {
		return err
	}
	if err := git("-C", dir, "fetch", "--depth", "1", "origin"); err != nil {
		return err
	}
	return git("-C", dir, "reset", "--hard", "FETCH_HEAD")
}

func findSkills(root, source string) ([]skill, error) {
	var skills []skill
	err := filepath.WalkDir(root, func(path string, entry fs.DirEntry, err error) error {
		if path == root && errors.Is(err, fs.ErrNotExist) {
			return nil
		}
		if err != nil {
			return err
		}
		if !entry.IsDir() {
			return nil
		}
		if path != root && strings.HasPrefix(entry.Name(), ".") {
			return fs.SkipDir
		}
		info, err := os.Lstat(filepath.Join(path, "SKILL.md"))
		if errors.Is(err, fs.ErrNotExist) {
			return nil
		}
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}
		name := filepath.Base(path)
		skills = append(skills, skill{name: source + "-" + name, path: path, label: source + ":" + name})
		return fs.SkipDir
	})
	return skills, err
}

func linkSkills(dir string, selected []skill) error {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	for _, skill := range selected {
		target, err := filepath.Rel(dir, skill.path)
		if err != nil {
			return err
		}
		if err := os.Symlink(target, filepath.Join(dir, skill.name)); err != nil {
			return err
		}
	}
	return nil
}
