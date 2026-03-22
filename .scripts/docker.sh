#!/bin/zsh

mkdir -p ~/.docker
echo '{}' >~/.docker/config.json
jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"]' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json
