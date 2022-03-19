# For working at work
FROM ubuntu:20.04
ENV http_proxy=http://proxy.cat.com:80
ENV https_proxy=http://proxy.cat.com:80

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y curl gnupg2 python3-pip python3-apt sshpass git openssh-client sudo && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# # For Homebrew
# RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# RUN useradd -m -s /bin/bash linuxbrew && \
#     echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# # USER linuxbrew
# # RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN adduser root sudo
    
RUN python3 -m pip install --upgrade pip cffi && \
    pip install ansible==2.9.27 && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /
COPY requirements.yml requirements.yml
RUN ansible-galaxy install -r requirements.yml --ignore-errors --force
# RUN ansible-galaxy install suzuki-shunsuke.pyenv-module

COPY . .
ENTRYPOINT /bin/bash
