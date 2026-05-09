#!/usr/bin/env bash

set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

sudo add-apt-repository universe -y
sudo apt-get update
sudo apt-get install -y gnome-shell-extension-manager gir1.2-gtop-2.0 gir1.2-clutter-1.0 gnome-sushi gnome-tweaks

pipx install gnome-extensions-cli --system-site-packages

gnome-extensions disable tiling-assistant@ubuntu.com || true
gnome-extensions disable ubuntu-appindicators@ubuntu.com || true
gnome-extensions disable ubuntu-dock@ubuntu.com || true
gnome-extensions disable ding@rastersoft.com || true

gext install "just-perfection-desktop@just-perfection"
gext install "space-bar@luchrioh"
gext install "AlphabeticalAppGrid@stuarthayhurst"

gnome-extensions enable "just-perfection-desktop@just-perfection"
gnome-extensions enable "space-bar@luchrioh"
gnome-extensions enable "AlphabeticalAppGrid@stuarthayhurst"

sudo install -m 0644 "$HOME/.local/share/gnome-shell/extensions/just-perfection-desktop@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml" /usr/share/glib-2.0/schemas/
sudo install -m 0644 "$HOME/.local/share/gnome-shell/extensions/space-bar@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml" /usr/share/glib-2.0/schemas/
sudo install -m 0644 "$HOME/.local/share/gnome-shell/extensions/AlphabeticalAppGrid@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml" /usr/share/glib-2.0/schemas/

sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-orange-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-orange'
gsettings set org.gnome.desktop.interface accent-color 'orange' 2>/dev/null || true

gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Super>BackSpace']"
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Shift>AudioPlay']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Shift><Super>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Shift><Super>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Shift><Super>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Shift><Super>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Shift><Super>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Shift><Super>6']"

gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"

gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'
