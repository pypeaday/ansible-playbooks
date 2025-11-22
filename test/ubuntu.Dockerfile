FROM ubuntu:latest

# Install minimum requirements via repo bootstrap script
COPY ./test/system-deps.sh /tmp/system-deps.sh
RUN chmod +x /tmp/system-deps.sh && /tmp/system-deps.sh

# Create test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

WORKDIR /home/testuser/ansible-playbooks

# Add local bin to PATH (for uv + ansible installed by bootstrap.sh)
ENV PATH="/home/testuser/.local/bin:${PATH}"

# Bootstrap
COPY --chown=testuser:testuser ./requirements.yml /home/testuser/ansible-playbooks/requirements.yml
COPY --chown=testuser:testuser ./bootstrap.sh /home/testuser/ansible-playbooks/bootstrap.sh
RUN chmod +x /home/testuser/ansible-playbooks/bootstrap.sh && \
    /home/testuser/ansible-playbooks/bootstrap.sh

# Copy playbooks
COPY --chown=testuser:testuser . /home/testuser/ansible-playbooks/

CMD ["bash"]
