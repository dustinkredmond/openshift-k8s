#!/bin/bash
#
# File Name: scale_deployment.sh

DEPLOYMENT_NAME=myapp

# Scale a deployment down to no pods
oc scale deploy/$DEPLOYMENT_NAME --replicas=0

# Scale a deployment up to two pods
oc scale deploy/$DEPLOYMENT_NAME --replicas=2
