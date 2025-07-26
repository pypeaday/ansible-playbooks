#!/usr/bin/env bash
# Simple Dotfiles Bootstrap for Homelab
# Usage: SSH_KEY_URL="https://your-server.com/ssh-key" REPO="git@github.com:user/dotfiles.git" ./dotfiles-bootstrap.sh

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration
SSH_KEY_URL="${SSH_KEY_URL:-}"
DOTFILES_REPO="${REPO:-git@github.com:pypeaday/dotfiles.git}"
DOTFILES_DIR="$HOME/dotfiles"

# Check for existing SSH keys
check_existing_ssh_key() {
    log_info "Checking for existing SSH keys..."
    
    # Check for common SSH key types
    for key_file in ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/id_ecdsa; do
        if [ -f "$key_file" ]; then
            log_info "Found existing SSH key: $key_file"
            
            # Test if key works with GitHub
            ssh_output=$(ssh -T -i "$key_file" -o StrictHostKeyChecking=no git@github.com 2>&1 || true)
            if echo "$ssh_output" | grep -q "You've successfully authenticated"; then
                log_info "SSH key has access to GitHub"
                return 0
            else
                log_info "SSH key exists but may not have GitHub access"
            fi
        fi
    done
    
    log_info "No working SSH key found"
    return 1
}

# Clone with existing SSH key
clone_with_existing_key() {
    log_info "Cloning dotfiles with existing SSH key..."
    
    if git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        log_info "Successfully cloned dotfiles"
        return 0
    else
        log_error "Failed to clone dotfiles with existing SSH key"
        return 1
    fi
}

# Download SSH key and clone dotfiles
clone_with_downloaded_key() {
    log_info "Downloading SSH key and cloning dotfiles..."
    
    if [ -z "$SSH_KEY_URL" ]; then
        log_error "SSH_KEY_URL not set and no existing SSH key found."
        log_error "Usage: SSH_KEY_URL='https://your-server.com/ssh-key' ./dotfiles-bootstrap.sh"
        return 1
    fi
    
    # Create temporary SSH key
    TEMP_KEY=$(mktemp)
    
    log_info "Downloading SSH key from $SSH_KEY_URL"
    if curl -sSL "$SSH_KEY_URL" > "$TEMP_KEY"; then
        chmod 600 "$TEMP_KEY"
        
        log_info "Cloning dotfiles from $DOTFILES_REPO"
        GIT_SSH_COMMAND="ssh -i $TEMP_KEY -o StrictHostKeyChecking=no" \
            git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
        
        # Clean up
        rm "$TEMP_KEY"
        return 0
    else
        log_error "Failed to download SSH key from $SSH_KEY_URL"
        rm -f "$TEMP_KEY"
        return 1
    fi
}

# Main setup function
setup_dotfiles() {
    log_info "Setting up dotfiles..."
    
    # Try existing SSH key first
    if check_existing_ssh_key; then
        if clone_with_existing_key; then
            return 0
        fi
    fi
    
    # Fall back to downloading SSH key
    log_info "Trying to download SSH key from server..."
    clone_with_downloaded_key
}

# Install dotfiles
install_dotfiles() {
    log_info "Installing dotfiles..."
    
    cd "$DOTFILES_DIR"
    
    # Run install script if it exists (check both install and install.sh)
    if [ -f "install" ]; then
        log_info "Running install script..."
        chmod +x install
        ./install
    elif [ -f "install.sh" ]; then
        log_info "Running install.sh..."
        chmod +x install.sh
        ./install.sh
    else
        log_error "No install script found in dotfiles directory (looked for 'install' and 'install.sh')"
        return 1
    fi
}

# Main execution
main() {
    log_info "Starting dotfiles bootstrap..."
    log_info "Repository: $DOTFILES_REPO"
    log_info "Target directory: $DOTFILES_DIR"
    
    # Remove existing dotfiles directory if it exists
    if [ -d "$DOTFILES_DIR" ]; then
        echo -e "${RED}[WARNING]${NC} Dotfiles directory already exists: $DOTFILES_DIR"
        read -p "Do you want to remove it and continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing existing dotfiles directory"
            rm -rf "$DOTFILES_DIR"
        else
            log_info "Aborted by user"
            exit 0
        fi
    fi
    
    # Setup dotfiles
    if setup_dotfiles; then
        log_info "✓ Dotfiles cloned successfully"
    else
        log_error "Failed to clone dotfiles"
        exit 1
    fi
    
    # Install dotfiles
    if install_dotfiles; then
        log_info "✓ Dotfiles installation complete!"
        log_info "You may need to restart your shell or run 'source ~/.zshrc'"
    else
        log_error "Dotfiles installation failed"
        exit 1
    fi
}

# Check dependencies
if ! command -v git >/dev/null; then
    log_error "git is required but not installed"
    exit 1
fi

if ! command -v curl >/dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

# Run main function
main "$@"
