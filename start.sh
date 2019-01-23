#!/bin/bash

# File: start.sh
# Author: Elad Gur
# 
# Description:
# 1.Create cluster using kubespray and vagrant
# 2.Port forwarding ?
# 3.Configure client kubectl and helm

vagrant up

echo "Finish creating kubernetes cluster"
echo "current nodes: "
./inventory/sample/artifacts/kubectl.sh get nodes

echo "** You can use the kubectl with the configuration using this script: inventory/sample/artifacts/kubectl.sh **"
echo "** To undeploy the cluster and delete the vm's, cd into kubespray main directory and use this cmd: vagrant destroy -f **"

echo "Configuring kubectl"
cp ./inventory/sample/artifacts/admin.conf ~/.kube/config
kubectl -n kube-system create serviceaccount tiller

echo "Configuring helm"
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
