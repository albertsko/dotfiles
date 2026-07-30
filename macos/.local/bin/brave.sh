#!/usr/bin/env bash
set -euo pipefail

open -n -a "Brave Browser" --args "--user-data-dir=$XDG_STATE_HOME/brave-personal"
