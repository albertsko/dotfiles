Personal dotfiles and machine setup managed with [mise](https://mise.jdx.dev/bootstrap.html).

### Install

1. On Linux, install the packages that Homebrew needs:

   ```sh
   sudo apt-get install -y build-essential procps curl file git
   ```

2. Install [Homebrew](https://brew.sh) and mise:

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/opt/homebrew/bin/brew shellenv)"              # macOS
   eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" # Linux
   brew install mise
   ```

3. Choose a profile (`macos`, `ubuntu26`, or `lima`) and set up the machine. mise clones this repository to `~/.local/state/dotfiles` and links `~/.config/mise` to its `mise/` directory:

   ```sh
   mise bootstrap -E macos \
     --from https://github.com/albertsko/dotfiles.git \
     --from-dir ~/.local/state/dotfiles \
     --config-dir mise
   ```

4. Save the profile for later runs. Do this even if step 3 stopped with an error:

   ```sh
   printf 'env = ["macos"]\n' >~/.config/mise/miserc.local.toml
   ```

5. Add the SSH public key that step 3 printed to GitHub as an authentication and signing key. On macOS, also sign in to the App Store so mise can install Xcode. Then run `mise bootstrap` again to finish the steps that need them.

After the first run, always run `mise bootstrap` without `--from`. The first run changes the repository's remote to SSH, and `--from` accepts only the original URL.

Add `--dry-run` to preview a run. When an existing file conflicts with a dotfile, mise stops before it writes anything. Move the file aside, or add `--force-dotfiles` to replace it.

The `limadev.sh` launcher provisions the Lima VM with the `lima` profile.

### Migrate a machine from Stow

Existing Stow links already count as applied, so there is no need to unstow first. Before the first run, clean up what Stow and the old installers left behind:

```sh
launchctl bootout "gui/$(id -u)/com.albertsko.gdrive"   # macOS: mise installs dev.mise.gdrive instead
rm ~/Library/LaunchAgents/com.albertsko.gdrive.plist
find ~ -maxdepth 4 -type l -lname '*dotfiles*' ! -exec test -e {} \; -print # review, then delete
```

Then move these files aside, because mise now manages them:

- `~/.gitconfig`: its settings now live in `~/.config/git/config`. Keep only machine-specific settings in it, because Git reads it last.
- `~/.ssh/config`: move machine-specific hosts to `~/.ssh/config.d/*.conf`.
- `~/.hushlogin` on macOS.

Link `~/.config/mise` to the existing checkout and run steps 4 and 5:

```sh
ln -s ~/.local/state/dotfiles/mise ~/.config/mise
```

### Update

```sh
git -C ~/.local/state/dotfiles pull
mise bootstrap
```

To upgrade Homebrew packages and mise tools, then apply the configuration:

```sh
mise run upgrade
```

The `mise-tool-update` service updates mise tools from the global config once a day in the background.

Run `mise bootstrap status` to compare the machine with the configuration.

### Layout

- `mise/config.toml` declares the dotfile groups and the packages for every profile.
- `mise/config.<profile>.toml` selects the dotfile groups of one profile and declares its packages, system settings, services, and `bootstrap` task.
- `mise/tasks/setup/` contains the setup steps that mise cannot declare. Each profile's `bootstrap` task runs the steps it needs.
- `shared/`, `ssh/`, `macos/`, `lima/`, and `ubuntu26/` are dotfile groups. mise links each committed file into `$HOME`.
- `apps/` contains repo-local applications and utilities.
- `agents/skills/` contains the skill library managed by the `skills.sh` launcher.
- `hk.pkl` configures the Git hooks that block commits containing secrets.
- `.stow` tells GNU Stow in other repositories to leave links into this repository alone.
