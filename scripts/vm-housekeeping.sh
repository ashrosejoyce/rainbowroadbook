#!/usr/bin/env bash
set -euo pipefail

# Docker: unused images, stopped containers, unused networks, build cache.
# Deliberately never prunes volumes - if this app stores data in a volume
# later, volume cleanup must stay a manual, reviewed decision.
docker image prune -af
docker container prune -f
docker network prune -f
docker builder prune -af

# apt: drop cached .deb files and packages nothing depends on anymore
apt-get clean
apt-get autoremove -y

# systemd journal: cap at 7 days of logs
journalctl --vacuum-time=7d