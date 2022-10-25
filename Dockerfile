FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS pype
ARG TAGS
RUN addgroup --gid 1000 nic
RUN adduser --gecos nic --uid 1000 --gid 1000 --disabled-password nic
RUN adduser nic sudo

# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

USER nic
WORKDIR /home/nic

FROM pype
COPY . .
# RUN ansible-galaxy install -r requirements.yml --ignore-errors
# ENV USER=nic
CMD ["sh", "-c", "ansible-playbook $TAGS personal.yml"]
