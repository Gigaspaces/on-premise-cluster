#!/bin/bash

# File: start.sh
# Author: Elad Gur
# 
# Description:
# 1.Create cluster using kubespray and vagrant
# 2.Port forwarding ?
# 3.Configure client kubectl and helm

cd kubespray-2.8.1

vagrant up

echo "Finish creating kubernetes cluster"
echo "current nodes: "
./inventory/sample/artifacts/kubectl.sh get nodes

echo "Configuring kubectl"
sed -i "s/certificate-authority-data:.*/insecure-skip-tls-verify: true/" admin.conf
sed -i "s/server: .*/server: https:\/\/192.168.33.204:4567/" admin.conf
cp ./inventory/sample/artifacts/admin.conf ~/.kube/config
echo "** For using kubectl from another hosts copy ~/.kube/config into ~/.kube/config at your machine **"

echo "Installing and Configuring helm"
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
./installHelm.sh
helm init --service-account tiller

echo "** To undeploy the cluster and delete the vm's, make use the stop.sh script"