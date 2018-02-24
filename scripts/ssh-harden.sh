#!/bin/bash

# Change SSH port to 9022
echo "Changing SSH Port to 9022..."
echo "" >> /etc/ssh/sshd_config
echo "Port 9022" >> /etc/ssh/sshd_config

# Create local user
echo "Creating user ${LOCAL_USER}..."
useradd -m ${LOCAL_USER}
mkdir /home/${LOCAL_USER}/.ssh
chown ${LOCAL_USER}:${LOCAL_USER} /home/${LOCAL_USER}/.ssh
cp /root/.ssh/authorized_keys /home/${LOCAL_USER}/.ssh/
chown ${LOCAL_USER}:${LOCAL_USER} /home/${LOCAL_USER}/.ssh/authorized_keys
echo "${LOCAL_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/10-local-user

# Delete centos user
echo "Deleting centos user..."
userdel -r centos

# Disable root ssh login
echo "Disabling root SSH login..."
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Reboot
echo "Rebooting..."
reboot