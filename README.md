# on-premise-cluster
Create kubernetes on premise cluster using kubespray and vagrant

* Running Instructions:
1. setup.sh - run this script first, this will configure the Vagrant file for starting the cluster for the next step
  (Including setting network_plugin=calico and os=centOS7, 4 CPU'S and 16GB RAM)
2. start.sh -  this will create the k8s cluster, configure the kubectl client (including ~/.kube/config) and configure helm client on the hosting machine
3. stop.sh - this will stop and cleanup clusther from the hosting machine

