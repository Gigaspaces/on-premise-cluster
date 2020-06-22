#!/bin/bash

source env.sh

cd kubespray-${KUBESPRAY_VERSION}

vagrant destroy -f
