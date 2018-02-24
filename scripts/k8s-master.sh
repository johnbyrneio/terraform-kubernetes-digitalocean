#!/bin/bash

sed -i "\$s/$/ --node-ip=${MASTER_IP}/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

kubeadm init --pod-network-cidr=192.168.0.0/16 \
             --apiserver-advertise-address ${MASTER_IP} \
             --apiserver-cert-extra-sans "kubernetes" \
             --token ${BOOTSTRAP_TOKEN}

kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml \
             --kubeconfig /etc/kubernetes/admin.conf