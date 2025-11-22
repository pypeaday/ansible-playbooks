#!/usr/bin/env bash
set -euo pipefail

# Default to Ubuntu if no distro specified
DISTRO="ubuntu"

if [[ $# -ge 1 ]]; then
  if [[ "$1" == "--os" && $# -ge 2 ]]; then
    DISTRO="$2"
  else
    DISTRO="$1"
  fi
fi

echo "Testing playbooks on $DISTRO..."

# Build the image
docker build -t ansible-test-$DISTRO -f test/$DISTRO.Dockerfile .

# Run ansible playbook with real installs inside the container
docker run --network host --rm ansible-test-$DISTRO bash -lc 'cd ~/ansible-playbooks && just base'
