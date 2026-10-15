#!/usr/bin/env bash
set -euo pipefail

script_dir="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$script_dir/../../..")}"
readonly MSB_IMAGE="${MSB_IMAGE:-msbdev:latest}"
readonly MSB_BASE_IMAGE="${MSB_BASE_IMAGE:-ubuntu:26.04}"
readonly MSB_BUILD_DIR="${MSB_BUILD_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/msb}"

if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then
	printf '%s\n' \
		'Usage: msb-build.sh' \
		'Build a minimal Ubuntu OCI image using Docker Buildx.' \
		'Homebrew and its packages live in a shared host directory.' \
		'Overrides: MSB_IMAGE, MSB_BASE_IMAGE, MSB_BUILD_DIR, MSB_BUILDER.'
	exit 0
fi

(($# == 0)) || {
	printf 'Unexpected argument: %s. Use msb-brew.sh to install formulas.\n' "$1" >&2
	exit 2
}

mkdir -p "$MSB_BUILD_DIR"
build_context="$(mktemp -d "$MSB_BUILD_DIR/build.XXXXXX")"
trap 'rm -rf -- "$build_context"' EXIT

cp -R -- "$DOTFILES_HOME/shared" "$DOTFILES_HOME/msb" "$build_context/"
cp -- "$DOTFILES_HOME/install.sh" "$build_context/"

platform=linux/arm64
[[ "$(uname -m)" != x86_64 ]] || platform=linux/amd64
builder_args=()
[[ -z "${MSB_BUILDER:-}" ]] || builder_args+=(--builder "$MSB_BUILDER")

docker buildx build "${builder_args[@]}" \
	--platform "$platform" --pull --progress=plain --provenance=false \
	--build-arg "BASE_IMAGE=$MSB_BASE_IMAGE" \
	--file "$build_context/msb/.config/msb/Dockerfile" \
	--tag "$MSB_IMAGE" \
	--output "type=oci,dest=$build_context/msbdev.oci.tar" \
	--metadata-file "$build_context/build.json" \
	"$build_context"

mv -- "$build_context/msbdev.oci.tar" "$MSB_BUILD_DIR/msbdev.oci.tar"
mv -- "$build_context/build.json" "$MSB_BUILD_DIR/build.json"
printf '%s\n' "$MSB_BUILD_DIR/msbdev.oci.tar"
