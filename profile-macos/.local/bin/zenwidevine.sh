#!/usr/bin/env bash
# Install the Widevine CDM into every Zen Browser profile.
# Zen has no Widevine license and does not ship the CDM on macOS.
# This script installs the CDM build that Firefox uses, from Mozilla's GMP manifest,
# and enables it, without waiting for Zen's own plugin updater.
# user.js pins the installed version, so re-run this script to update Widevine.
set -euo pipefail

readonly ZEN_APP="/Applications/Zen.app"
readonly PROFILES_DIR="$HOME/Library/Application Support/Zen/Profiles"
readonly MANIFEST_URL="https://raw.githubusercontent.com/mozilla-firefox/firefox/refs/heads/release/toolkit/content/gmp-sources/widevinecdm.json"
readonly BEGIN_MARK="// BEGIN zenwidevine.sh"
readonly END_MARK="// END zenwidevine.sh"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

json() {
	plutil -extract "$1" raw -o - "$manifest" || die "unexpected Widevine manifest: $1"
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == Darwin ]] || die 'macOS only'
[[ -d "$ZEN_APP" ]] || die "Zen is not installed: $ZEN_APP"
[[ -d "$PROFILES_DIR" ]] || die "no Zen profiles, start Zen once first: $PROFILES_DIR"
! pgrep -qf "$ZEN_APP/Contents/MacOS/" || die 'quit Zen first'

# Zen is universal, so check the hardware. uname -m reports x86_64 under Rosetta.
if [[ "$(sysctl -n hw.optional.arm64 2>/dev/null)" == 1 ]]; then
	platform=Darwin_aarch64-gcc3 abi=aarch64-gcc3
else
	platform=Darwin_x86_64-gcc3-u-i386-x86_64 abi=x86_64-gcc3
fi

work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT
manifest="$work_dir/widevinecdm.json"
crx="$work_dir/widevine.crx3"

curl -fsSL --proto '=https' --proto-redir '=https' -o "$manifest" "$MANIFEST_URL" || die 'cannot download the Widevine manifest'
version="$(json vendors.gmp-widevinecdm.version)"
url="$(json "vendors.gmp-widevinecdm.platforms.$platform.fileUrl")"
hash="$(json "vendors.gmp-widevinecdm.platforms.$platform.hashValue")"
[[ "$version" =~ ^[0-9.]+$ ]] || die "unexpected Widevine version: $version"
[[ "$url" == https://* ]] || die "unexpected Widevine URL: $url"

printf 'Downloading Widevine %s\n' "$version"
curl -fSL --proto '=https' --proto-redir '=https' --progress-bar -o "$crx" "$url" || die 'cannot download Widevine'
[[ "$(shasum -a 512 "$crx" | cut -d ' ' -f 1)" == "$hash" ]] || die 'Widevine checksum mismatch'

# A CRX3 file is a 12-byte prefix, a signed header, then a zip archive.
[[ "$(head -c 4 "$crx")" == Cr24 ]] || die 'Widevine download is not a CRX3 file'
header_len="$(od -An -tu4 -j8 -N4 "$crx" | tr -d ' ')"
[[ "$header_len" =~ ^[0-9]+$ ]] || die 'cannot read the CRX3 header'
tail -c "+$((12 + header_len + 1))" "$crx" >"$work_dir/widevine.zip"
unzip -q "$work_dir/widevine.zip" -d "$work_dir/unpacked" || die 'cannot unpack Widevine'

# Firefox flattens the archive and keeps only the CDM and its metadata.
cdm_dir="$work_dir/gmp-widevinecdm/$version"
mkdir -p -- "$cdm_dir"
find "$work_dir/unpacked" -type f \( -name '*.dylib' -o -name '*.sig' -o -name '*.info' \
	-o -name '*.txt' -o -name LICENSE -o -name manifest.json \) -exec cp -- {} "$cdm_dir/" \;
[[ -f "$cdm_dir/libwidevinecdm.dylib" ]] || die 'Widevine archive has no libwidevinecdm.dylib'
chmod 700 "$cdm_dir"/*
xattr -cr "$cdm_dir"

prefs="$(
	cat <<EOF
$BEGIN_MARK
user_pref("media.eme.enabled", true);
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.gmp-widevinecdm.visible", true);
user_pref("media.gmp-widevinecdm.version", "$version");
user_pref("media.gmp-widevinecdm.abi", "$abi");
$END_MARK
EOF
)"

installed=0
for profile in "$PROFILES_DIR"/*/; do
	profile="${profile%/}"
	[[ -f "$profile/prefs.js" ]] || continue

	# Copy first, so an interrupted run keeps the previous CDM.
	rm -rf -- "$profile/gmp-widevinecdm.tmp"
	cp -R -- "$work_dir/gmp-widevinecdm" "$profile/gmp-widevinecdm.tmp"
	rm -rf -- "$profile/gmp-widevinecdm"
	mv -- "$profile/gmp-widevinecdm.tmp" "$profile/gmp-widevinecdm"

	user_js="$profile/user.js"
	touch -- "$user_js"
	# Drop only complete blocks, so a stray marker never deletes other prefs.
	awk -v begin="$BEGIN_MARK" -v end="$END_MARK" '
		$0 == begin { printf "%s", block; block = $0 ORS; open = 1; next }
		open { block = block $0 ORS; if ($0 == end) { block = ""; open = 0 }; next }
		{ print }
		END { printf "%s", block }
	' "$user_js" >"$work_dir/user.js"
	# Write in place to keep a symlinked user.js.
	cat -- "$work_dir/user.js" >"$user_js"
	# Start the block on its own line.
	if [[ -s "$user_js" && -n "$(tail -c 1 "$user_js")" ]]; then
		printf '\n' >>"$user_js"
	fi
	printf '%s\n' "$prefs" >>"$user_js"

	printf 'Installed Widevine %s: %s\n' "$version" "$profile"
	installed=$((installed + 1))
done

((installed > 0)) || die "no Zen profiles with prefs.js in $PROFILES_DIR"
