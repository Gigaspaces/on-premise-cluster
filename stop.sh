#!/bin/bash

# File: stop.sh
# Author: Elad Gur
# 
# Description:
# Delete kubernetes cluster and delete resources

cd kubespray-2.8.1

vagrant destroy -f
