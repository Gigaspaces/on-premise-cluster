#!/bin/bash
set -e
source env.sh

cd kubespray-${KUBESPRAY_VERSION}

vagrant up

echo "Finish creating kubernetes cluster"

echo "Configuring kubectl"
pushd ./inventory/sample/artifacts
sed -i "s/certificate-authority-data:.*/insecure-skip-tls-verify: true/" admin.conf
sed -i "s/server: .*/server: https:\/\/192.168.33.204:4567/" admin.conf
cp admin.conf ~/.kube/config
echo "** For using kubectl from another hosts copy ~/.kube/config into ~/.kube/config at your machine **"

echo "Installing and Configuring helm"
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
popd
cd ..
export DESIRED_VERSION=v2.16.1
./installHelm.sh
helm init --service-account tiller

echo "** To undeploy the cluster and delete the vm's, make use the stop.sh script"
