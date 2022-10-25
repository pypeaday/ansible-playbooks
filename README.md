# README

My ansible playbooks for setting up new machines. This is an ever WIP and is
mostly for me to get familiar with ansible

A few notes:

1. group_vars/ doesn't do anything, I don't have something configured right so the variables that are necessary are right in `personal.yml`
2. There are some hard-coded paths yet on my machine here -> not everything is `{{ lookup('env', 'HOME')  }}` yet - there's a few of those that I want figured out better
3. `ansible-galaxy collection install community.general` + `ansible-galaxy install -r requirements.yml` are required
4. Not everything I need is in here 
    - tailscale

## Setup

The `personal.yml` playbook sets up my development machine with my tooling - lots of those notes are found in my [dotfiles repo](https://www.github.com/pypeaday/dotfiles)

The `zfs.yml` is for installing ZFS on Ubuntu based distros and setting up `sanoid` for snapshot management

