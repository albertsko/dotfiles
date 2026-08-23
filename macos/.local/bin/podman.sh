#!/usr/bin/env bash
set -euo pipefail

podman machine init \
	--rootful \
	--swap 2048 \
	--now \
	--update-connection
