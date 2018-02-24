#!/bin/bash

# Disable firewalld
echo "Disabling firewalld..."
systemctl disable firewalld && sudo systemctl stop firewalld

# yum update all the things
echo "Running yum update..."
yum update -y

# Set selinux to permissive
echo "Disabling selinux..."
setenforce 0
cat << EOF > /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF

# Install Docker and configure it to use overlay2
echo "Installing Docker..."
yum install -y docker
echo "STORAGE_DRIVER=overlay2" >> /etc/sysconfig/docker-storage-setup
systemctl enable docker && systemctl start docker

# Set sysctl for iptbales stuff
echo "Setting sysctl settings..."
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
sysctl -p

# Add Kubernetes yum repo
echo "Enabling Kubernetes yum repo"
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install Kubernetes binaries
echo "Installing Kubernetes binaries..."
yum install -y kubelet kubeadm kubectl

# Start and enable kubelet
systemctl enable kubelet && systemctl start kubelet

# Cleanup
echo "Cleaning up yum data..."
yum clean all
rm -rf /var/cache/yum

# Reboot
echo "Rebooting..."
reboot