#!/usr/bin/env bash
set -euo pipefail

# Default to Ubuntu if no distro specified
DISTRO=${1:-ubuntu}

echo "Testing playbooks on $DISTRO..."

# Build the image
docker build -t ansible-test-$DISTRO -f test/$DISTRO.Dockerfile .

# Run the container with interactive shell
docker run --rm -it ansible-test-$DISTRO
