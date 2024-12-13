# List available recipes
default:
    @just --list

# Run ansible-playbook with common options
_run *args:
    ansible-playbook -i inventory.yml --limit localhost site.yml {{args}}

# Configure everything (development machine)
all:
    @just _run -e "install_development_tools=true" -e "install_docker=true" -e "setup_shell=true"

# Configure as server (base + docker + git + shell)
server:
    @just _run --tags "base,git,shell,docker" -e "install_docker=true"

# Install development tools
dev:
    @just _run --tags "base,git,shell,dev,brew" -e "install_development_tools=true" -e "install_docker=true"

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
