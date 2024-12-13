# Ansible Playbooks

A collection of Ansible playbooks for setting up development machines and servers. These playbooks automate the installation and configuration of various development tools, system utilities, and server components.

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/ansible-playbooks.git
   cd ansible-playbooks
   ```

2. Run the bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

3. Choose your setup:
   ```bash
   just dev    # For a full development environment
   just server # For a basic server setup
   just all    # For everything
   ```

## Roles

### Base System (`base-system`)
- Essential system packages and utilities
- Development tools (git, tmux, etc.)
- System monitoring tools (htop, btm)
- Terminal utilities (fzf, bandwhich, tealdeer)

### Homebrew (`homebrew`)
- Installs Homebrew package manager
- Configures Homebrew paths
- Manages Homebrew formulae
- Required for Neovim installation

### Neovim (`neovim`)
- Installs Neovim via Homebrew
- Ensures consistent installation across different systems
- Requires Homebrew role

### Git Setup (`git-setup`)
- Configures global git settings
- Sets up SSH keys
- Installs lazygit
- Configures git credential helper

### Shell Setup (`shell-setup`)
- Configures ZSH with modern tools
- Sets up Starship prompt
- Configures direnv
- Adds useful shell aliases and functions
- Installs JetBrains Mono Nerd Font

### Development Tools (`development`)
- Node.js and npm
- Rust and Cargo
- Zellij terminal multiplexer
- Tree-sitter
- Kubernetes tools:
  - kubectl
  - Helm
  - k9s
  - kubecm
- Infrastructure tools:
  - Terraform

### Docker (`docker`)
- Installs Docker using geerlingguy.docker role
- Adds user to docker group
- Installs lazydocker

## Usage

### Common Commands

```bash
just dev     # Setup development environment (base + brew + neovim + git + shell + dev tools)
just server  # Basic server setup (base + brew + neovim + git + shell + docker)
just all     # Install everything
```

### Individual Components

```bash
just base    # Install base system packages (includes brew and neovim)
just git     # Setup git configuration
just shell   # Setup shell configuration (includes brew and neovim)
just brew    # Install Homebrew
just neovim  # Install Neovim via Homebrew
```

### Testing

Test the playbooks in Docker containers:
```bash
just ubuntu  # Test on Ubuntu
just fedora  # Test on Fedora
just arch    # Test on Arch Linux
```

## Role Dependencies

The roles are executed in the following order to ensure proper dependencies:
1. `base-system`: Core system packages
2. `homebrew`: Package manager (required for Neovim)
3. `neovim`: Text editor installation
4. Other roles (git, shell, development, docker)

## Inventory Structure

- `workstations`: Development machines
  - `localhost`: Local development machine
  - `babyblue`: Additional workstation

- `servers`: Remote servers (via Tailscale)
  - `ghost`: Main server
  - `ghost-vault`: Vault server

- `development`: Group containing all workstations
- `homelab`: Group containing all servers

## Variables

Key variables that control role execution:
- `install_development_tools`: Enable development tools installation
- `install_docker`: Enable Docker installation
- `setup_shell`: Enable shell configuration
- `setup_monitoring`: Enable system monitoring tools

## Requirements

- Ansible 2.9+
- Python 3.x
- `just` command runner (installed via bootstrap)

## Notes

- The playbooks are designed to be idempotent and can be run multiple times
- Docker installation requires root privileges
- Some roles (like development) are opt-in and need to be explicitly enabled
- The bootstrap script installs all necessary dependencies
- Neovim is installed via Homebrew to ensure consistency across systems and containers
