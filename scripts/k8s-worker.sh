#!/bin/bash

sed -i "\$s/$/ --node-ip=${PRIVATE_IP}/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

kubeadm join --token ${BOOTSTRAP_TOKEN} ${MASTER_IP}:6443 \
             --discovery-token-unsafe-skip-ca-verification