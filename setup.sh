#!/bin/bash

# File: setup.sh
# Author: Elad Gur
#
# Description:
# 1.Setup prerequiste for creating kubernetes cluster with kubespray and vagrant

function deleteFile() {
	file=$1

    if [ -f $file ]; then
    	echo "Deleting file ${file}..."
        rm $file
        ensureFileDeleted $file
    else
   		echo "File ${file} not exist"
    fi
}

function ensureFileDeleted () {
    file=$1

    if [ -f $file ]; then
   		echo 'Failed to delete file'
   		exit 1
    else
        echo 'File deleted successfully'
    fi
}
source env.sh
echo "Setup kubernetes cluster using kubespray"

echo "Unzip kubespray into current directory"
wget https://github.com/kubernetes-sigs/kubespray/archive/v${KUBESPRAY_VERSION}.tar.gz
tar -xf v${KUBESPRAY_VERSION}.tar.gz
cd kubespray-${KUBESPRAY_VERSION}

# Install dependencies from requirements.txt
sudo pip install -r requirements.txt
# Copy inventory/sample as inventory/mycluster
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
sudo pip3.6 install ruamel.yaml
declare -a IPS=(10.10.1.3 10.10.1.4 10.10.1.5)
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}
echo 'Deleting hosts.ini file if exist'
deleteFile "inventory/sample/hosts.ini"
echo 'Checking if config.rb file existing and configuring env'

if [ -d "vagrant" ]; then
    echo 'vagrant directory detected'
else
    mkdir vagrant
fi

configFile="vagrant/config.rb"

if [ -f "${configFile}" ]; then
    echo '${configFile} file detected, using existing configuration'
else
    echo 'Creating config file and setting configuration (os = cenOS7, 1 kubeMaster and vm_memory = 8192)'
    touch ${configFile}
    echo "\$os = \"centos\" " >> $configFile
    echo '$forwarded_ports = {6443 => 4567, 30890 => 30890}' >> $configFile
    echo "\$network_plugin = \"calico\" " >> $configFile
    # echo "\$kube_master_instances = 1" >> $configFile
    echo "\$vm_memory = 16384" >> $configFile
    echo "\$vm_cpus = 4" >> $configFile
    echo "\$local_path_provisioner_enabled = true" >> $configFile
fi

echo 'Setting download_run_once to false'
sed -i "s/\"download_run_once\": \"True\",/\"download_run_once\": \"False\",/g" Vagrantfile

echo 'removing --ask-become-pass'
sed -i "s/, \"--ask-become-pass\"//g" Vagrantfile

echo "Setting kubeconfig_localhost and kubectl_localhost to True for getting the kubectl configured in inventory/sample/artifacts directory"
echo "kubeconfig_localhost: true" >> inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
echo "kubectl_localhost: true" >> inventory/sample/group_vars/k8s-cluster/k8s-cluster.yml
