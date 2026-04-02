function gw
    set -l cmd "$argv[1]"
    set -l name "$argv[2]"
    set -l main_path (git worktree list | head -n 1 | awk '{print $1}')

    if test -z "$main_path"
        echo "Error: Not a git repository."
        return 1
    end

    set -l repo_name (basename "$main_path")
    set -l parent_dir (dirname "$main_path")
    set -l target_path "$parent_dir/$repo_name.$name"

    switch "$cmd"
        case switch
            if test -z "$name"
                echo "Usage: gw switch <branch-name>"
                return 1
            end

            set -l existing_path (git worktree list | grep "\[$name\]" | awk '{print $1}')
            if test -n "$existing_path"
                echo "Branch '$name' is already active at: $existing_path"
                cd "$existing_path"
                return
            end

            if test -d "$target_path"
                echo "Directory exists, switching to $target_path"
                cd "$target_path"
                return
            end

            if git show-ref --verify --quiet "refs/heads/$name"
                echo "Branch '$name' exists. Adding worktree..."
                git worktree add "$target_path" "$name"
            else
                echo "Creating new branch '$name' and adding worktree..."
                git worktree add -b "$name" "$target_path"
            end

            cd "$target_path"
        case remove
            if test -z "$name"
                echo "Usage: gw remove <branch-name>"
                return 1
            end

            if not git worktree list | grep -q "\[$name\]"
                echo "Error: No worktree found for branch '$name'."
                return 1
            end

            if test -d "$target_path"; and test -n "$(git -C "$target_path" status --porcelain)"
                echo "Warning: Branch '$name' has uncommitted changes."
                echo "Please commit or stash them before removing the worktree."
                return 1
            end

            if string match -q -- "$target_path*" "$PWD"
                echo "Leaving worktree..."
                cd "$main_path"
            end

            echo "Removing worktree and deleting branch '$name'..."
            git worktree remove "$target_path"
            git branch -d "$name"
        case list
            git worktree list
        case '*'
            echo "Commands: switch, remove, list"
    end
end
