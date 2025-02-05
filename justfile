# List available recipes
default:
    @just --list

# Run ansible-playbook with common options
_run *args:
    mkdir -p /tmp/ansible-playbooks-setup
    ansible-playbook -K -i inventory.yml --limit localhost site.yml {{args}}

# Configure everything (development machine)
all:
    @just _run -e "install_development_tools=true" -e "install_docker=true" -e "setup_shell=true"

# Configure as server (base + docker + git + shell + cockpit)
server:
    @just _run --tags "base,brew,neovim,git,shell,docker" -e "install_docker=true" -e "install_cockpit=true"

# Install development tools
dev:
    @just _run --tags "base,brew,neovim,git,shell,dev" -e "install_development_tools=true" -e "install_docker=true"

# Setup shell configuration
shell:
    @just _run --tags "brew,neovim,shell"

# Setup git configuration
git:
    @just _run --tags git

# Install base system packages
base:
    @just _run --tags "base,brew,neovim"

# Setup brew
brew:
    @just _run --tags brew

# Setup neovim
neovim:
    @just _run --tags neovim

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
