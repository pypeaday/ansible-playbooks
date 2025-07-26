# Simple Dotfiles Automation for Homelab

Fast, simple way to get your dotfiles onto new machines with just a curl command.

## 🚀 Super Simple Setup

### One-liner Bootstrap
```bash
# Download SSH key from your server and clone dotfiles
SSH_KEY_URL="https://your-server.com/ssh-key" REPO="git@github.com:user/dotfiles.git" ./dotfiles-bootstrap.sh

# Or as a one-liner download and run
SSH_KEY_URL="https://your-server.com/ssh-key" REPO="git@github.com:user/dotfiles.git" \
curl -sSL https://your-server.com/dotfiles-bootstrap.sh | bash
```

## 🔧 Setup Instructions

### Step 1: Create a Dotfiles SSH Key
```bash
# Generate a dedicated SSH key for dotfiles
ssh-keygen -t ed25519 -f ~/.ssh/dotfiles_key -C "dotfiles-access"

# Add the public key to GitHub
cat ~/.ssh/dotfiles_key.pub
# Copy this and add to: https://github.com/settings/keys
```

### Step 2: Put SSH Key on Your Server

**Option A: Simple Python Server (Easiest)**
```bash
# Copy the key to your server
scp ~/.ssh/dotfiles_key your-server:~/dotfiles_key

# On your server, run the simple key server
python3 simple-ssh-key-server.py
# This serves your SSH key at http://your-server:8080/ssh-key
```

**Option B: Static File Server**
```bash
# Copy key to web server directory
scp ~/.ssh/dotfiles_key your-server:/var/www/html/ssh-key
# Now accessible at https://your-server.com/ssh-key
```

### Option B: Ansible Integration

1. **Configure your inventory:**
```yaml
# inventory.yml
all:
  vars:
    github_username: "your-username"
    dotfiles_ssh_key_url: "https://your-server.com/api/dotfiles/ssh-key"  # optional
```

2. **Run with Ansible:**
```bash
just full  # Everything including dotfiles
# or
just dotfiles  # Just dotfiles
```

### Option C: Manual but Fast

1. **Put this script on your server** (accessible via curl):
```bash
# Upload dotfiles-bootstrap.sh to your server
scp dotfiles-bootstrap.sh your-server:/var/www/html/
```

2. **One-liner from anywhere:**
```bash
curl -sSL https://your-server.com/dotfiles-bootstrap.sh | bash
```

## 🔐 SSH Key Server Setup

### 1. Start the SSH Key Manager
```bash
cd ssh-key-manager
pip install -r requirements.txt
export SSH_KEY_MANAGER_TOKEN="$(openssl rand -base64 32)"
echo "Save this token: $SSH_KEY_MANAGER_TOKEN"
python main.py
```

### 2. Store Your Dotfiles SSH Key
```bash
# Generate dedicated key for dotfiles
ssh-keygen -t ed25519 -f ~/.ssh/dotfiles_key -C "dotfiles-access"

# Add public key to GitHub
cat ~/.ssh/dotfiles_key.pub
# Copy and add to: https://github.com/settings/keys

# Store in key manager
python client.py store dotfiles ~/.ssh/dotfiles_key.pub --private-key ~/.ssh/dotfiles_key --comment "Dotfiles repository access"
```

### 3. Test the Setup
```bash
# Test key retrieval
curl -H "Authorization: Bearer $SSH_KEY_MANAGER_TOKEN" \
     "http://localhost:8000/dotfiles/ssh-key"

# Test bootstrap script generation
curl -H "Authorization: Bearer $SSH_KEY_MANAGER_TOKEN" \
     "http://localhost:8000/dotfiles/bootstrap-script?repo_url=git@github.com:user/dotfiles.git"
```

## 📁 Dotfiles Repository Structure

The automation supports multiple dotfiles structures:

### Structure 1: install.sh (Preferred)
```
dotfiles/
├── install.sh          # Main install script
├── .zshrc
├── .gitconfig
└── config/
    ├── nvim/
    └── alacritty/
```

### Structure 2: GNU Stow
```
dotfiles/
├── zsh/
│   └── .zshrc
├── git/
│   └── .gitconfig
└── nvim/
    └── .config/nvim/
```

### Structure 3: Direct Files
```
dotfiles/
├── zshrc               # Will be linked as ~/.zshrc
├── gitconfig           # Will be linked as ~/.gitconfig
└── config/
    └── nvim/           # Will be linked as ~/.config/nvim
```

## 🎯 Usage Examples

### New Machine Setup
```bash
# 1. Bootstrap system
curl -sSL https://raw.githubusercontent.com/user/ansible-playbooks/main/bootstrap.sh | bash

# 2. Get dotfiles (choose one)
# Option A: If you have SSH key server
SSH_KEY_MANAGER_TOKEN="your-token" \
curl -sSL https://your-server.com/dotfiles-bootstrap.sh | bash

# Option B: If you have existing SSH key
./dotfiles-bootstrap.sh your-username dotfiles

# Option C: Full Ansible setup
just full -e "github_username=your-username"
```

### Update Dotfiles
```bash
cd ~/dotfiles
git pull
./install.sh  # or your preferred install method
```

## 🔒 Security Considerations

1. **SSH Key Server**: Use HTTPS and strong tokens
2. **Dedicated Keys**: Use separate SSH keys for dotfiles
3. **Token Management**: Rotate tokens regularly
4. **Network Security**: Consider VPN or private networks
5. **Key Cleanup**: Remove temporary keys after use

## 🐛 Troubleshooting

### SSH Key Issues
```bash
# Test SSH connection to GitHub
ssh -T git@github.com

# Check SSH agent
ssh-add -l

# Debug SSH
ssh -vT git@github.com
```

### Permission Issues
```bash
# Fix SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub
```

### Dotfiles Installation Issues
```bash
# Manual installation
cd ~/dotfiles
ls -la  # Check structure
./install.sh  # or manual symlinks
```

## 🚀 Pro Tips

1. **Use the SSH key server method** - it's the most automated
2. **Test your setup** in a container or VM first
3. **Keep your dotfiles install.sh idempotent** - safe to run multiple times
4. **Use absolute paths** in your dotfiles scripts
5. **Consider using GNU Stow** for complex configurations

Your dotfiles will now be just one command away on any new machine! 🎉
