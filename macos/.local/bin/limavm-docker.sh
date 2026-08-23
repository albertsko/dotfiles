#!/usr/bin/env bash
set -euo pipefail

limactl start \
	--name=docker \
	--vm-type=vz \
	--cpus=4 \
	--memory=2 \
	--disk=100 \
	--mount-writable \
	--rosetta \
	--tty=false \
	template:docker-rootful

docker context create lima-docker \
	--docker "host=unix://${HOME}/.lima/docker/sock/docker.sock"
docker context use lima-docker
