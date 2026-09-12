// Command skills links selected skills into directories used by coding agents.
package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"

	"charm.land/huh/v2"
)

const (
	remoteName = "mattpocock-skills"
	cacheName  = "albertsko-skills"
)

const usage = `Usage:
  skills.sh             choose which skills are enabled
  skills.sh --update    refresh the remote skills first
  skills.sh --cd        open a shell in the dotfiles repository`

var defaultSpec = appSpec{
	sources: []sourceSpec{
		{name: "local", path: "agents/skills"},
		{
			name:   remoteName,
			gitURL: "https://github.com/mattpocock/skills",
			path:   "skills",
		},
	},
	targets: []targetSpec{
		{name: "agents", path: ".agents/skills"},
		{name: "claude", path: ".claude/skills"},
		{name: "codex", path: ".codex/skills"},
	},
}

var errCancelled = errors.New("cancelled")

type options struct {
	update bool
}

type sourceSpec struct {
	name   string
	gitURL string
	path   string
}

type targetSpec struct {
	name string
	path string
}

type appSpec struct {
	sources []sourceSpec
	targets []targetSpec
}

type appPaths struct {
	homeDir  string
	repoRoot string
	cacheDir string
}

type skill struct {
	name  string
	path  string
	label string
}

type linkPlan struct {
	path   string
	target string
	temp   string
}

type targetPlan struct {
	dir    string
	remove []string
	create []linkPlan
}

type app struct {
	spec    appSpec
	paths   appPaths
	stderr  io.Writer
	git     func(context.Context, ...string) error
	symlink func(oldname, newname string) error
	choose  func(skills []skill, selected []string) ([]string, error)
}

func main() {
	os.Exit(realMain(os.Args[1:], os.Stderr))
}

func realMain(args []string, stderr io.Writer) int {
	fail := func(err error) int {
		_, _ = fmt.Fprintf(stderr, "Error: %v\n", err)
		return 1
	}

	opts, err := parseOptions(args)
	if err != nil {
		return fail(err)
	}

	app, err := newApp(stderr)
	if err != nil {
		return fail(err)
	}
	if err := app.run(context.Background(), opts); err != nil {
		return fail(err)
	}
	return 0
}

func parseOptions(args []string) (options, error) {
	var result options
	for _, arg := range args {
		if arg != "-update" && arg != "--update" {
			return options{}, fmt.Errorf("unexpected argument %q\n%s", arg, usage)
		}
		result.update = true
	}
	return result, nil
}

func newApp(stderr io.Writer) (*app, error) {
	repoRoot := os.Getenv("DOTFILES_HOME")
	if repoRoot == "" {
		return nil, errors.New("DOTFILES_HOME is not set")
	}

	homeDir, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("cannot determine home directory: %w", err)
	}
	homeDir, err = canonicalPath(homeDir)
	if err != nil {
		return nil, fmt.Errorf("cannot resolve home directory: %w", err)
	}
	repoRoot, err = canonicalPath(repoRoot)
	if err != nil {
		return nil, fmt.Errorf("cannot resolve DOTFILES_HOME: %w", err)
	}

	dataHome := os.Getenv("XDG_DATA_HOME")
	if dataHome == "" {
		dataHome = filepath.Join(homeDir, ".local", "share")
	}
	dataHome, err = canonicalPath(dataHome)
	if err != nil {
		return nil, fmt.Errorf("cannot resolve data directory: %w", err)
	}

	return &app{
		spec: defaultSpec,
		paths: appPaths{
			homeDir:  homeDir,
			repoRoot: repoRoot,
			cacheDir: filepath.Join(dataHome, cacheName),
		},
		stderr: stderr,
		git: func(ctx context.Context, args ...string) error {
			cmd := exec.CommandContext(ctx, "git", args...)
			cmd.Stdout = stderr
			cmd.Stderr = stderr
			return cmd.Run()
		},
		symlink: os.Symlink,
		choose: func(skills []skill, selected []string) ([]string, error) {
			choices := make([]huh.Option[string], 0, len(skills))
			for _, skill := range skills {
				choices = append(choices, huh.NewOption(skill.label, skill.label))
			}

			chosen := append([]string{}, selected...)
			err := huh.NewForm(huh.NewGroup(
				huh.NewMultiSelect[string]().
					Title("Select skills to enable").
					Options(choices...).
					Value(&chosen),
			)).Run()
			if errors.Is(err, huh.ErrUserAborted) {
				return nil, errCancelled
			}
			return chosen, err
		},
	}, nil
}

func canonicalPath(path string) (string, error) {
	current, err := filepath.Abs(path)
	if err != nil {
		return "", err
	}

	var missing []string
	for {
		resolved, err := filepath.EvalSymlinks(current)
		if err == nil {
			return filepath.Join(append([]string{resolved}, missing...)...), nil
		}
		if !errors.Is(err, fs.ErrNotExist) {
			return "", err
		}

		parent := filepath.Dir(current)
		if parent == current {
			return "", err
		}
		missing = append([]string{filepath.Base(current)}, missing...)
		current = parent
	}
}

func (a *app) run(ctx context.Context, opts options) error {
	if err := a.syncSources(ctx, opts.update); err != nil {
		return err
	}

	skills, err := a.loadSkills()
	if err != nil {
		return err
	}
	selected, err := a.selectSkills(skills)
	if errors.Is(err, errCancelled) {
		if _, err := fmt.Fprintln(a.stderr, "No changes made."); err != nil {
			return fmt.Errorf("cannot report cancellation: %w", err)
		}
		return nil
	}
	if err != nil {
		return err
	}

	plans, err := a.planLinks(selected)
	if err != nil {
		return err
	}
	if err := a.applyPlans(plans); err != nil {
		return err
	}

	if _, err := fmt.Fprintf(a.stderr, "Enabled %d skill(s) across %d directories.\n", len(selected), len(a.spec.targets)); err != nil {
		return fmt.Errorf("cannot report enabled skills: %w", err)
	}
	return nil
}

func (a *app) syncSources(ctx context.Context, update bool) error {
	for _, source := range a.spec.sources {
		if source.gitURL == "" {
			continue
		}
		if err := a.syncSource(ctx, source, update); err != nil {
			return fmt.Errorf("source %q: %w", source.name, err)
		}
	}
	return nil
}

func (a *app) syncSource(ctx context.Context, source sourceSpec, update bool) error {
	dir := a.sourceDir(source)
	_, err := os.Stat(dir)
	if errors.Is(err, fs.ErrNotExist) {
		if err := os.MkdirAll(a.paths.cacheDir, 0o755); err != nil {
			return fmt.Errorf("cannot create cache: %w", err)
		}
		if err := a.git(ctx, "clone", "--depth", "1", source.gitURL, dir); err != nil {
			return fmt.Errorf("cannot clone %s: %w", source.gitURL, err)
		}
		return nil
	}
	if err != nil {
		return fmt.Errorf("cannot inspect clone: %w", err)
	}
	if !update {
		return nil
	}

	refreshErr := a.git(ctx, "-C", dir, "fetch", "--depth", "1", "origin")
	if refreshErr == nil {
		refreshErr = a.git(ctx, "-C", dir, "reset", "--hard", "FETCH_HEAD")
	}
	if refreshErr == nil {
		return nil
	}
	if _, err := fmt.Fprintf(a.stderr, "Warning: source %q not refreshed: %v\n", source.name, refreshErr); err != nil {
		return fmt.Errorf("cannot report refresh warning: %w", err)
	}
	return nil
}

func (a *app) loadSkills() ([]skill, error) {
	var skills []skill
	owners := map[string]string{}
	for _, source := range a.spec.sources {
		discovered, err := findSkills(a.sourceRoot(source))
		if err != nil {
			return nil, fmt.Errorf("source %q: %w", source.name, err)
		}
		for _, skill := range discovered {
			if owner := owners[skill.name]; owner != "" {
				return nil, fmt.Errorf("skill %q comes from both %q and %q", skill.name, owner, source.name)
			}
			owners[skill.name] = source.name
			skill.label = source.name + ":" + skill.name
			skills = append(skills, skill)
		}
	}
	return skills, nil
}

func (a *app) selectSkills(skills []skill) ([]skill, error) {
	var preselected []string
	for _, skill := range skills {
		selected := true
		for _, dir := range a.targetDirs() {
			target, err := resolveLink(filepath.Join(dir, skill.name))
			if err != nil || target != skill.path {
				selected = false
				break
			}
		}
		if selected {
			preselected = append(preselected, skill.label)
		}
	}

	labels, err := a.choose(skills, preselected)
	if err != nil {
		return nil, err
	}

	byLabel := make(map[string]skill, len(skills))
	for _, skill := range skills {
		byLabel[skill.label] = skill
	}
	selected := make([]skill, 0, len(labels))
	for _, label := range labels {
		skill, ok := byLabel[label]
		if !ok {
			return nil, fmt.Errorf("unknown selection %q", label)
		}
		selected = append(selected, skill)
	}
	return selected, nil
}

func (a *app) planLinks(selected []skill) ([]targetPlan, error) {
	plans := make([]targetPlan, 0, len(a.spec.targets))
	for _, target := range a.spec.targets {
		plan, err := a.planTarget(a.targetDir(target), selected)
		if err != nil {
			return nil, fmt.Errorf("target %q: %w", target.name, err)
		}
		plans = append(plans, plan)
	}
	return plans, nil
}

func (a *app) planTarget(dir string, selected []skill) (targetPlan, error) {
	entries := map[string]fs.DirEntry{}
	info, err := os.Lstat(dir)
	if err == nil && info.Mode()&fs.ModeSymlink != 0 {
		return targetPlan{}, fmt.Errorf("%s is a symlink; skills only manages real directories", dir)
	}
	if err == nil && !info.IsDir() {
		return targetPlan{}, fmt.Errorf("%s is not a directory", dir)
	}
	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		return targetPlan{}, fmt.Errorf("cannot inspect %s: %w", dir, err)
	}
	if err == nil {
		listed, err := os.ReadDir(dir)
		if err != nil {
			return targetPlan{}, fmt.Errorf("cannot read %s: %w", dir, err)
		}
		for _, entry := range listed {
			entries[entry.Name()] = entry
		}
	}

	plan := targetPlan{dir: dir}
	removing := map[string]bool{}
	for name, entry := range entries {
		if entry.Type()&fs.ModeSymlink == 0 {
			continue
		}
		if strings.HasPrefix(name, ".") && !strings.HasPrefix(name, ".skills-link-") {
			continue
		}
		target, err := resolveLink(filepath.Join(dir, name))
		if err != nil {
			return targetPlan{}, fmt.Errorf("cannot read link %s: %w", filepath.Join(dir, name), err)
		}
		if a.manages(target) {
			plan.remove = append(plan.remove, filepath.Join(dir, name))
			removing[name] = true
		}
	}
	sort.Strings(plan.remove)

	for _, skill := range selected {
		path := filepath.Join(dir, skill.name)
		if _, exists := entries[skill.name]; exists && !removing[skill.name] {
			return targetPlan{}, fmt.Errorf("cannot link %s: an unmanaged entry already exists", path)
		}
		target, err := filepath.Rel(dir, skill.path)
		if err != nil {
			return targetPlan{}, fmt.Errorf("cannot make link to %s relative to %s: %w", skill.path, dir, err)
		}
		plan.create = append(plan.create, linkPlan{path: path, target: target})
	}
	return plan, nil
}

func (a *app) applyPlans(plans []targetPlan) error {
	for _, plan := range plans {
		if err := os.MkdirAll(plan.dir, 0o755); err != nil {
			return fmt.Errorf("cannot create %s: %w", plan.dir, err)
		}
	}
	if err := a.stageLinks(plans); err != nil {
		return err
	}
	if err := installLinks(plans); err != nil {
		cleanupStagedLinks(plans)
		return err
	}
	return removeUnselectedLinks(plans)
}

func (a *app) stageLinks(plans []targetPlan) error {
	for planIndex := range plans {
		for linkIndex := range plans[planIndex].create {
			link := &plans[planIndex].create[linkIndex]
			placeholder, err := os.CreateTemp(plans[planIndex].dir, ".skills-link-")
			if err != nil {
				cleanupStagedLinks(plans)
				return fmt.Errorf("cannot stage link %s: %w", link.path, err)
			}
			link.temp = placeholder.Name()
			if err := placeholder.Close(); err != nil {
				cleanupStagedLinks(plans)
				return fmt.Errorf("cannot close staged link %s: %w", link.temp, err)
			}
			if err := os.Remove(link.temp); err != nil {
				cleanupStagedLinks(plans)
				return fmt.Errorf("cannot prepare staged link %s: %w", link.temp, err)
			}
			if err := a.symlink(link.target, link.temp); err != nil {
				cleanupStagedLinks(plans)
				return fmt.Errorf("cannot stage link %s: %w", link.path, err)
			}
		}
	}
	return nil
}

func installLinks(plans []targetPlan) error {
	for _, plan := range plans {
		for _, link := range plan.create {
			if err := os.Rename(link.temp, link.path); err != nil {
				return fmt.Errorf("cannot install link %s: %w", link.path, err)
			}
		}
	}
	return nil
}

func removeUnselectedLinks(plans []targetPlan) error {
	for _, plan := range plans {
		keep := map[string]bool{}
		for _, link := range plan.create {
			keep[link.path] = true
		}
		for _, path := range plan.remove {
			if keep[path] {
				continue
			}
			if err := os.Remove(path); err != nil {
				return fmt.Errorf("cannot remove %s: %w", path, err)
			}
		}
	}
	return nil
}

func cleanupStagedLinks(plans []targetPlan) {
	for _, plan := range plans {
		for _, link := range plan.create {
			if link.temp != "" {
				_ = os.Remove(link.temp)
			}
		}
	}
}

func (a *app) sourceDir(source sourceSpec) string {
	return filepath.Join(a.paths.cacheDir, source.name)
}

func (a *app) sourceRoot(source sourceSpec) string {
	root := a.paths.repoRoot
	if source.gitURL != "" {
		root = a.sourceDir(source)
	}
	return filepath.Join(root, filepath.FromSlash(source.path))
}

func (a *app) targetDirs() []string {
	dirs := make([]string, 0, len(a.spec.targets))
	for _, target := range a.spec.targets {
		dirs = append(dirs, a.targetDir(target))
	}
	return dirs
}

func (a *app) targetDir(target targetSpec) string {
	return filepath.Join(a.paths.homeDir, filepath.FromSlash(target.path))
}

func (a *app) manages(path string) bool {
	for _, source := range a.spec.sources {
		root := a.sourceRoot(source)
		if source.gitURL != "" {
			root = a.paths.cacheDir
		}
		relative, err := filepath.Rel(root, path)
		if err == nil && relative != ".." && !strings.HasPrefix(relative, ".."+string(os.PathSeparator)) {
			return true
		}
	}
	return false
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

func findSkills(root string) ([]skill, error) {
	var skills []skill
	err := filepath.WalkDir(root, func(path string, entry fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if path != root && entry.IsDir() && strings.HasPrefix(entry.Name(), ".") {
			return fs.SkipDir
		}
		if !entry.IsDir() {
			return nil
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

		skills = append(skills, skill{name: filepath.Base(path), path: path})
		return fs.SkipDir
	})
	if errors.Is(err, fs.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	sort.Slice(skills, func(i, j int) bool {
		return skills[i].name < skills[j].name
	})
	return skills, nil
}
