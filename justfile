# List available recipes
default:
    @just --list

# Run ansible-playbook with common options
_run *args:
    mkdir -p /tmp/ansible-playbooks-setup
    PATH="$HOME/.local/bin:$HOME/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/bin:$PATH" ansible-playbook -K -i inventory.yml --limit localhost site.yml {{args}}

# Configure everything (development machine)
all:
    @just _run -e install_development_tools=true -e install_docker=true -e setup_shell=true -e install_python_uv=true -e setup_ssh_keys=true

# Configure as server (base + docker + git + shell + cockpit)
server:
    @just _run --tags "base,brew,neovim,git,ssh,python,shell,docker" -e install_docker=true -e install_cockpit=true -e install_python_uv=true -e setup_ssh_keys=true

# Install development tools
dev:
    @just _run --tags "base,brew,neovim,git,ssh,python,shell,dev" -e install_development_tools=true -e install_docker=true -e install_python_uv=true -e setup_ssh_keys=true

# Setup shell configuration
shell:
    @just _run --tags "brew,neovim,shell"

# Setup Python with uv
python:
    @just _run --tags "python,uv" -e install_python_uv=true

# Setup SSH keys
ssh:
    @just _run --tags "ssh,keys" -e setup_ssh_keys=true

# Setup dotfiles
dotfiles:
    @just _run --tags "dotfiles" -e setup_dotfiles=true

# Full setup including dotfiles
full:
    @just _run -e install_development_tools=true -e install_docker=true -e setup_shell=true -e install_python_uv=true -e setup_ssh_keys=true -e setup_dotfiles=true

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
