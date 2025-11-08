#!/bin/bash
set -eux

# Cleanup logs, SSH host keys, history, etc.
rm -rf /tmp/* /var/tmp/*
rm -f /etc/ssh/ssh_host_*
rm -f /var/log/*log /root/.bash_history
cloud-init clean --logs

# Regenerate machine ID
truncate -s 0 /etc/machine-id
systemd-machine-id-setup

