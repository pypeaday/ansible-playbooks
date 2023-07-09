## Notes

Making playbooks for each server for now...

ghost is replacing hogwarts, so I'm setting up server stuff + zfs and sanoid, and kvm
ghost-vault is the backup

First thing is to run init.sh to setup pyenv, tailscale, and see ssh instructions I might have forgotten
That will have also installed ansible via pipx, so then we `ansible-galaxy install -r requirements.yml` and then run whichever playbook we need to
