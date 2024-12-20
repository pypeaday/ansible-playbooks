FROM ubuntu:latest

# Install minimum requirements
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    pipx \
    sudo \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

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

# Bootstrap
COPY --chown=testuser:testuser ./requirements.yml /home/testuser/ansible-playbooks/requirements.yml
COPY --chown=testuser:testuser ./bootstrap.sh /home/testuser/ansible-playbooks/bootstrap.sh
RUN chmod +x /home/testuser/ansible-playbooks/bootstrap.sh && \
    /home/testuser/ansible-playbooks/bootstrap.sh

# Copy playbooks
COPY --chown=testuser:testuser . /home/testuser/ansible-playbooks/

CMD ["bash"]
