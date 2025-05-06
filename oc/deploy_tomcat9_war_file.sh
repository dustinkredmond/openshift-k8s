#!/bin/bash
#
# File Name: deploy_tomcat9_war_file.sh
# Created: 2025-05-06
# By: Dustin K. Redmond <dustin@dustinredmond.com>
# Usage: Deploys local WAR file on Kubernetes cluster
#        and creates a route to it for external usage.

### CHANGE ME ###
PROJECT_NAME=mytomcat-app
WAR_FILE_LOCATION=/home/myuser/myapp.war
CONTAINER_IMAGE=tomcat:9.0
### END OF CHANGES ###

### Start of deployment ###

# Create new Project(Namespace)
oc new-project $PROJECT_NAME
# Create Deployment
oc create deploy $PROJECT_NAME --image $CONTAINER_IMAGE

# Create ConfigMap to hold WAR file
oc create configmap $PROJECT_NAME-cm \
  --from-file=$WAR_FILE_LOCATION

# Mount ConfigMap WAR file to local pod volume mountpoint
oc set volume deploy/$PROJECT_NAME \
  --add --type configmap \
  --configmap-name $PROJECT_NAME-cm \
  --mount-path /usr/local/tomcat/webapps

# Expose a Service and a Route
oc expose deploy/$PROJECT_NAME --port=8080
oc expose svc $PROJECT_NAME

# Check Deployment ready and pods created
oc get deploy,pods

# Get Route, paste it into a browser and verify connectivity
oc get route
