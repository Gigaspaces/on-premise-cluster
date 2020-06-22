#!/bin/bash

# File: add_agent.sh
# Author: Elad Gur
# 
# Description:
# To add kubernetes agent from host(srv-1) run the following scripts: ./add_agent.sh <your agent ip>

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo "Please enter agent ip as argumant"
    exit 1
fi

AGENT_IP=$1

echo "copy kube config to agent"
scp ~/.kube/config root@${AGENT_IP}:~/.kube/config

echo "ssh into agent"
ssh xap@AGENT_IP

echo "Installin kubectl into agent"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl

echo "install helm"
wget https://raw.githubusercontent.com/helm/helm/master/scripts/get
mv get installHelm.sh
chmod +x installHelm.sh
./installHelm.sh
helm init --client-only

echo "Current nodes on cluster:"
kubectl get nodes