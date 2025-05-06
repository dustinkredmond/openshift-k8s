#!/bin/bash
#
# File Name: deploy_postgres.sh
# Created: 2025-05-06
# By: Dustin K. Redmond <dustin@dustinredmond.com>
# Usage: Spin up PostgreSQL database on OpenShift.

### CHANGE ME ###
PROJECT_NAME=test-db1
DB_NAME=testdb
DB_USER=test
DB_PASSWORD=test123
DB_ADMIN_PASSWORD=myS3curePa55

CONTAINER_IMAGE=registry.redhat.io/rhel9/postgresql-16:9.5-1745933843
### END OF CHANGES ###

### Start the deployment

# Create new new Project (namespace)
oc new-project $PROJECT_NAME

# Create Deployment
oc create deploy $PROJECT_NAME --image $CONTAINER_IMAGE

# Create 5Gi PersistentVolumeClaim using whatever the cluster's default StorageClass is.
# This will hold $PGDATA directory, including database data files.
oc set volumes deploy/$PROJECT_NAME \
	--add \
	--name "$PROJECT_NAME-pv" \
	--type persistentVolumeClaim \
	--claim-mode rwo \
	--claim-size 5Gi \
	--mount-path /var/lib/pgsql/data \
	--claim-name "$PROJECT_NAME-pvc"

# Set environment variables for Postgres config
oc set env deploy/$PROJECT_NAME \
  -e POSTGRESQL_USER=$DB_USER \
  -e POSTGRESQL_PASSWORD=$DB_PASSWORD \
  -e POSTGRESQL_DATABASE=$DB_NAME \
  -e POSTGRESQL_ADMIN_PASSWORD=$DB_ADMIN_PASSWORD

# Scale deployment to zero pods, then back to one to ensure
# changes are quickly propogated.

oc scale deploy/$PROJECT_NAME --replicas=0
oc scale deploy/$PROJECT_NAME --replicas=1

# Run the following port-forward command on your local
# PC if you need to access the DB remotely via your admin
# tool or IDE.
# Usage: oc port-forward <pod-name> <local-port>:<remote-port>
#oc port-forward <pod-name> 15432:5432
