#!/usr/bin/env bash

set -euo pipefail

source ./.profile.local

brew_prefix="$(brew --prefix)"

if [[ "$(command -v brew)" != "$brew_prefix/bin/brew" ]]; then
	echo "Error: brew is not first from Homebrew prefix." >&2
	exit 1
fi

if [[ "$(command -v pkg-config)" != "$brew_prefix/bin/pkg-config" ]]; then
	echo "Error: pkg-config is not first from Homebrew prefix." >&2
	exit 1
fi

if [[ "$(command -v pkgconf)" != "$brew_prefix/bin/pkgconf" ]]; then
	echo "Error: pkgconf is not first from Homebrew prefix." >&2
	exit 1
fi

brew list --formula pkgconf >/dev/null
brew list --formula libyaml >/dev/null
brew list --formula zlib >/dev/null
brew list --formula libpq >/dev/null
brew list --formula mysql-client >/dev/null
brew list --formula openssl@3 >/dev/null

pkg-config --exists yaml-0.1
pkg-config --exists zlib
pkg-config --exists libpq
pkg-config --exists mysqlclient
pkg-config --exists openssl

pc_path="$(pkg-config --variable pc_path pkg-config)"

if [[ ":$pc_path:" != *":$brew_prefix/lib/pkgconfig:"* ]]; then
	echo "Error: pkg-config does not include Homebrew lib/pkgconfig." >&2
	exit 1
fi

if [[ ":$PKG_CONFIG_PATH:" != *":$brew_prefix/opt/zlib/lib/pkgconfig:"* ]]; then
	echo "Error: zlib pkg-config path is missing." >&2
	exit 1
fi

if [[ "$(pkgconf --path zlib)" != "$brew_prefix/opt/zlib/lib/pkgconfig/zlib.pc" ]]; then
	echo "Error: zlib does not resolve to brewed zlib." >&2
	exit 1
fi

if [[ "$(pkgconf --path libpq)" != "$brew_prefix/opt/libpq/lib/pkgconfig/libpq.pc" ]]; then
	echo "Error: libpq does not resolve to brewed libpq." >&2
	exit 1
fi

if [[ "$(pkgconf --path mysqlclient)" != "$brew_prefix/opt/mysql-client/lib/pkgconfig/mysqlclient.pc" ]]; then
	echo "Error: mysqlclient does not resolve to brewed mysql-client." >&2
	exit 1
fi

echo "Ubuntu install checks passed."
