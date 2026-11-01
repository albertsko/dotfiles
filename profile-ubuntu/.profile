# shellcheck shell=sh
. "$HOME/.profile.shared"
[ -f "$HOME/.profile.local" ] && . "$HOME/.profile.local"

# Interactive bash login shells skip ~/.bashrc. Source it last, because it may exec fish.
case $- in
*i*) [ -n "${BASH_VERSION-}" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc" ;;
esac
