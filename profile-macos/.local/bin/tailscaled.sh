#!/usr/bin/env bash
set -euo pipefail

if ! pgrep -x tailscaled >/dev/null 2>&1; then
	echo "Starting tailscaled in background..."
	sudo tailscaled \
		--tun=userspace-networking \
		--socks5-server=localhost:1055 \
		--outbound-http-proxy-listen=localhost:1055 &
	tailscale wait --timeout=15s
fi

if ! tailscale status; then
	echo "Tailscale status check failed. Run: tailscale up --auth-key <YOUR_AUTH_KEY>"
fi
