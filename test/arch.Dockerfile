FROM archlinux:latest

# Install minimum requirements
RUN pacman -Syu --noconfirm \
    python \
    python-pip \
    python-pipx \
    sudo \
    git \
    curl \
    && pacman -Scc --noconfirm

# Create test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

WORKDIR /home/testuser/ansible-playbooks

# Install Ansible using pipx
RUN pipx install ansible

# Add local bin to PATH
ENV PATH="/home/testuser/.local/bin:${PATH}"

# Copy playbooks
COPY --chown=testuser:testuser . /home/testuser/ansible-playbooks/

CMD ["bash"]
