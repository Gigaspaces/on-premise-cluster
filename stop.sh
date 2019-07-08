#!/bin/bash

# File: stop.sh
# Author: Elad Gur
# 
# Description:
# Delete kubernetes cluster and delete resources
source env.sh

cd kubespray-${KUBESPRAY_VERSION}

vagrant destroy -f
