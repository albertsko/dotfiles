#!/usr/bin/env bash

set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

fc_cache_bin="/usr/bin/fc-cache"
if [[ ! -x "$fc_cache_bin" ]]; then
	fc_cache_bin="$(command -v fc-cache)"
fi

gsettings_bin="/usr/bin/gsettings"
if [[ ! -x "$gsettings_bin" ]]; then
	gsettings_bin="$(command -v gsettings)"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

inter_release_json="$(curl -fsSL https://api.github.com/repos/rsms/inter/releases/latest)"
inter_tag="$(jq -r '.tag_name // empty' <<<"$inter_release_json")"
inter_zip_url="$(jq -r '[.assets[] | select(.name | test("^Inter-.*\\.zip$")) | .browser_download_url][0] // empty' <<<"$inter_release_json")"

if [[ -z "$inter_tag" || -z "$inter_zip_url" ]]; then
	echo "Error: Failed to resolve latest Inter release asset." >&2
	exit 1
fi

nerd_release_json="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest)"
nerd_tag="$(jq -r '.tag_name // empty' <<<"$nerd_release_json")"
jetbrains_zip_url="$(jq -r '[.assets[] | select(.name == "JetBrainsMono.zip") | .browser_download_url][0] // empty' <<<"$nerd_release_json")"

if [[ -z "$nerd_tag" || -z "$jetbrains_zip_url" ]]; then
	echo "Error: Failed to resolve latest JetBrains Mono Nerd Font release asset." >&2
	exit 1
fi

inter_zip="$tmp_dir/inter.zip"
jetbrains_zip="$tmp_dir/jetbrainsmono.zip"
inter_extract="$tmp_dir/inter"
jetbrains_extract="$tmp_dir/jetbrains"

curl -fsSL "$inter_zip_url" -o "$inter_zip"
curl -fsSL "$jetbrains_zip_url" -o "$jetbrains_zip"

unzip -oq "$inter_zip" -d "$inter_extract"
unzip -oq "$jetbrains_zip" -d "$jetbrains_extract"

mapfile -t inter_fonts < <(fd -a -t f '^Inter-.*\.otf$' "$inter_extract" | sort)
mapfile -t jetbrains_fonts < <(fd -a -t f '^JetBrainsMonoNerdFontMono-.*\.ttf$' "$jetbrains_extract" | sort)

if [[ "${#inter_fonts[@]}" -eq 0 ]]; then
	echo "Error: No Inter static font files found in release $inter_tag." >&2
	exit 1
fi

if [[ "${#jetbrains_fonts[@]}" -eq 0 ]]; then
	echo "Error: No JetBrains Mono Nerd Font files found in release $nerd_tag." >&2
	exit 1
fi

fonts_root="$HOME/.local/share/fonts"
inter_target_dir="$fonts_root/Inter"
jetbrains_target_dir="$fonts_root/JetBrainsMonoNerd"

mkdir -p "$fonts_root"
rm -rf "$inter_target_dir" "$jetbrains_target_dir"
mkdir -p "$inter_target_dir" "$jetbrains_target_dir"

cp "${inter_fonts[@]}" "$inter_target_dir/"
cp "${jetbrains_fonts[@]}" "$jetbrains_target_dir/"

printf '%s\n' "$inter_tag" >"$inter_target_dir/.release"
printf '%s\n' "$nerd_tag" >"$jetbrains_target_dir/.release"

"$fc_cache_bin" -f "$fonts_root"

gtk4_dir="$HOME/.config/gtk-4.0"
gtk4_settings_file="$gtk4_dir/settings.ini"
mkdir -p "$gtk4_dir"
cat >"$gtk4_settings_file" <<'EOF_GTK'
[Settings]
gtk-font-rendering=manual
gtk-hint-font-metrics=1
EOF_GTK

fontconfig_dir="$HOME/.config/fontconfig/conf.d"
fontconfig_file="$fontconfig_dir/10-dotfiles-fonts.conf"
mkdir -p "$fontconfig_dir"
cat >"$fontconfig_file" <<'EOF_FONTCONFIG'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
    <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
  </match>

  <match target="pattern">
    <test name="family" qual="any"><string>sans-serif</string></test>
    <edit name="family" mode="assign" binding="strong"><string>Inter</string></edit>
  </match>

  <match target="pattern">
    <test name="family" qual="any"><string>monospace</string></test>
    <edit name="family" mode="assign" binding="strong"><string>JetBrainsMono Nerd Font Mono</string></edit>
  </match>

  <alias>
    <family>sans-serif</family>
    <accept><family>Noto Color Emoji</family></accept>
  </alias>

  <alias>
    <family>monospace</family>
    <accept><family>Noto Color Emoji</family></accept>
  </alias>
</fontconfig>
EOF_FONTCONFIG

environment_dir="$HOME/.config/environment.d"
environment_file="$environment_dir/20-freetype-properties.conf"
mkdir -p "$environment_dir"
cat >"$environment_file" <<'EOF_ENV'
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
EOF_ENV

"$gsettings_bin" set org.gnome.desktop.interface font-name 'Inter 11'
"$gsettings_bin" set org.gnome.desktop.interface document-font-name 'Inter 11'
"$gsettings_bin" set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 11'
"$gsettings_bin" set org.gnome.desktop.interface font-antialiasing 'rgba'
"$gsettings_bin" set org.gnome.desktop.interface font-hinting 'slight'
"$gsettings_bin" set org.gnome.desktop.interface font-rgba-order 'rgb'
"$gsettings_bin" set org.gnome.desktop.interface text-scaling-factor 1.0

echo "Installed Inter $inter_tag and JetBrains Mono Nerd Font $nerd_tag."
echo "Log out and log back in to apply FREETYPE_PROPERTIES and GTK4 settings everywhere."
