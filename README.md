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
- `test/` - Docker environments for testing playbooks:
  - `ubuntu.Dockerfile` - Ubuntu test environment
  - `fedora.Dockerfile` - Fedora test environment
  - `arch.Dockerfile` - Arch Linux test environment
  - `test.sh` - Helper script for running tests

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

## Development and Testing

### Docker Test Environments

The `test/` directory contains Dockerfiles for testing the playbooks in clean environments. This helps ensure the playbooks work correctly across different distributions and allows for quick iteration without affecting your host system.

Available test environments:
- Ubuntu (latest)
- Fedora (latest)
- Arch Linux (latest)

To test in a clean environment:

```bash
# Test on Ubuntu (default)
./test/test.sh

# Test on Fedora
./test/test.sh fedora

# Test on Arch Linux
./test/test.sh arch
```

Each container:
- Uses a clean installation of the distribution
- Has a non-root user with sudo access
- Has Ansible pre-installed
- Mounts your playbooks directory
- Is removed when you exit (--rm flag)

### Development Workflow

1. Make changes to playbooks or roles
2. Test in a clean environment:
   ```bash
   ./test/test.sh
   cd ansible-playbooks
   just check        # Verify syntax
   just all          # Run all playbooks
   ```
3. If something fails:
   - Exit the container (it will be removed automatically)
   - Make your fixes
   - Start a new clean container to test again
4. Once everything works in the test environment, run on your actual system

This workflow ensures your changes work across different environments and prevents your development system from getting into an inconsistent state during testing.

## Tags

- `base` - Base system packages and tools
- `brew` - Homebrew installation
- `dev` - Development tools
- `git` - Git and SSH configuration
- `shell` - Shell setup (ZSH + Oh-My-Zsh)
