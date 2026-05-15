package main

import (
	"os"
	"path/filepath"
	"strings"
)

// buildOkGitignoreLine builds a .gitignore line for existing path
func buildOkGitignoreLine(base, sub string) string {
	full := filepath.Join(base, sub)
	info, err := os.Stat(full)
	if err != nil {
		return ""
	}

	relPath, err := filepath.Rel(base, full)
	if err != nil {
		return ""
	}

	gitPath := filepath.ToSlash(relPath)

	if !strings.HasPrefix(gitPath, "/") {
		gitPath = "/" + gitPath
	}

	if info.IsDir() {
		if !strings.HasSuffix(gitPath, "/") {
			gitPath += "/"
		}
	}

	return gitPath
}
