
# On-premise Kubernetes cluster
Create Kubernetes on-premise cluster using kubespray and vagrant

### First setup
1. setup.sh - run this script first, this will configure the Vagrant file for starting the cluster for the next step
  (Including setting network_plugin=calico and os=centOS7, 4 CPU'S and 16GB RAM)
2. start.sh -  this will create the k8s cluster, configure the kubectl client (including ~/.kube/config) and configure helm client on the hosting machine
3. copy-to-agent-207.sh - Copies the .kube/config file to newman agent 207

### Restarting the cluster
1. stop.sh - this will stop and cleanup cluster from the hosting machine
2. start.sh - see above




