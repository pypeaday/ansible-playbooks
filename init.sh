#!/bin/bash

# Dry run option
read -p "Do you want to do a dry run? (y/n): " dry_run

sudo apt install gcc cmake libssl-dev zlib1g-dev build-essential ccache cifs-utils cmake curl dconf-editor direnv gettext htop libevent-dev libncurses5-dev libncursesw5-dev libpthread-stubs0-dev libtool libtool-bin lm-sensors lsof ninja-build openssh-server pkg-config virtualenv python3-dev python3-pip python3-venv ripgrep rename stow tar tree unzip libffi-dev fzf -y

# Function to execute or print commands
execute_or_print() {
  if [ "$dry_run" == "y" ] || [ "$dry_run" == "Y" ]; then
    echo "$1"
  else
    eval "$1"
  fi
}

# Install Pyenv
echo "Installing Pyenv..."
execute_or_print "curl https://pyenv.run | bash"

# Add Pyenv to the current shell session
echo "Adding Pyenv to the shell session..."
execute_or_print "export PATH=\"\$HOME/.pyenv/bin:\$PATH\""
execute_or_print "eval \"\$(pyenv init -)\""

# Install Tailscale
read -p "Do you want to install Tailscale? (y/n): " install_tailscale
if [ "$install_tailscale" == "y" ] || [ "$install_tailscale" == "Y" ]; then
    echo "Installing Tailscale..."
    execute_or_print "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null"
    execute_or_print "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list"
    execute_or_print "sudo apt update -y"
    execute_or_print "sudo apt install tailscale -y"

    # Start Tailscale
    echo "Starting Tailscale..."
    execute_or_print "sudo tailscale up"
else
    echo "Skipping Tailscale installation."
fi

# Install Python 3.10.11 with Pyenv
echo "Installing Python 3.10.11..."
execute_or_print "pyenv install 3.10.11"
execute_or_print "pyenv global 3.10.11"

# Install Pipx
echo "Installing Pipx..."
execute_or_print "python -m pip install --user pipx"
execute_or_print "python -m pipx ensurepath"

export PATH=$HOME/.local/bin:$PATH

# Install Ansible with Pipx
echo "Installing Ansible..."
execute_or_print "python -m pipx install ansible"

# Notes for SSH in case I forget

# Generate SSH key pair
echo "Generate SSH key pair..."
echo "ssh-keygen -t rsa -b 4096 -C \"your_email@example.com\""

# Start the SSH agent
echo "Start SSH agent..."
echo "eval \"\$(ssh-agent -s)\""

# Add the SSH private key to the agent
echo "Add SSH private key to the agent..."
echo "ssh-add ~/.ssh/id_rsa"

# Print the public key
echo "Public key:"
echo "cat ~/.ssh/id_rsa.pub"

echo "SSH key setup instructions displayed."

echo "Setup completed."
