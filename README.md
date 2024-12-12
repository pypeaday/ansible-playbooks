# Ansible Playbooks

A collection of Ansible playbooks for setting up and maintaining my development environment.

## Structure

- `site.yml` - Main playbook that handles all configurations
- `roles/` - Individual roles for different aspects of configuration:
  - `base-system/` - Essential system packages and tools (neovim, fzf, ripgrep, etc.)
  - `homebrew/` - Homebrew package manager installation
  - `development/` - Development tools (Node.js, Rust, direnv, etc.)
  - `shell-setup/` - ZSH configuration with Oh-My-Zsh
  - `git-setup/` - Git configuration and SSH key setup

## Getting Started

### Bootstrap Installation

To get started, run the bootstrap script to install Ansible and its dependencies:

```bash
./bootstrap.sh
```

This script will:
1. Detect your Linux distribution
2. Install Python3 and pip if needed
3. Install Ansible using pip

### Running the Playbooks

The playbooks use the `just` command runner for convenience. Here are the available commands:

```bash
just                # List all available commands
just all            # Run all playbooks
just base           # Install base system packages
just brew           # Install Homebrew
just dev            # Install development tools
just git            # Setup git configuration
just shell          # Setup shell (ZSH + Oh-My-Zsh)
just check          # Check playbook syntax
```

You can also run specific playbooks directly with ansible-playbook:

```bash
ansible-playbook site.yml              # Run everything
ansible-playbook site.yml --tags base  # Run only base system setup
```

## Tags

- `base` - Base system packages and tools
- `brew` - Homebrew installation
- `dev` - Development tools
- `git` - Git and SSH configuration
- `shell` - Shell setup (ZSH + Oh-My-Zsh)
