# List available recipes
default:
    @just --list

# Run ansible-playbook with common options
_run *args:
    ansible-playbook site.yml {{args}}

# Configure everything
all:
    @just _run

# Install development tools
dev:
    @just _run --tags dev

# Setup shell configuration
shell:
    @just _run --tags shell

# Setup git configuration
git:
    @just _run --tags git

# Setup base system
base:
    @just _run --tags base

# Setup brew
brew:
    @just _run --tags brew

# Check syntax only
check:
    @just _run --check

# Test with Ubuntu
ubuntu:
    ./test/test.sh

# Test with Fedora
fedora:
    ./test/test.sh --os fedora

# Test with Arch
arch:
    ./test/test.sh --os arch
