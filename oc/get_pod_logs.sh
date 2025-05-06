# File Name: get_pod_logs.sh
# Usage: Examples for getting pod logs

# First, get the name of the pod whose logs
# you are interested in.
oc get pods

# Get pod logs for individual pod
oc logs <pod-name>

# Follow pod logs, like tail -f
oc logs <pod-name> -f

# Get pods based off a label, can span multiple pods
oc logs -l app=myapp


