#!/usr/bin/env bash

set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

sudo apt-get update
sudo apt-get install -y ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

if dpkg-query -W -f='${db:Status-Status}\n' openssh-server 2>/dev/null | grep -qx installed; then
	sudo ufw allow OpenSSH
fi

if [[ ! -x /usr/local/bin/ufw-docker ]]; then
	sudo curl -fsSL https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker -o /usr/local/bin/ufw-docker
	sudo chmod +x /usr/local/bin/ufw-docker
fi

sudo ufw --force enable
sudo systemctl enable ufw

if ! sudo ufw-docker check >/dev/null 2>&1; then
	sudo ufw-docker install
fi

sudo ufw reload
