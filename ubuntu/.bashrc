#!/usr/bin/env bash

# pnpm
export PNPM_HOME="/home/albertsko/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end


[[ $- == *i* ]] || return

exec fish
