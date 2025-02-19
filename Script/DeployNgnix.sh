#!/bin/bash

# Function to log messages
log() {
    echo "[INFO] $1"
}

# Define YAML file name
YAML_FILE="nginx-deployment.yaml"
YAML_URL="https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml"

# Download YAML file
log "Downloading Nginx deployment YAML..."
curl -s -o "$YAML_FILE" "$YAML_URL"

if [ ! -f "$YAML_FILE" ]; then
    echo "[ERROR] Failed to download $YAML_FILE. Exiting."
    exit 1
fi

# Apply the YAML configuration
log "Applying deployment..."
kubectl apply -f "$YAML_FILE"

# Wait for deployment to be ready
log "Waiting for deployment to be ready..."
kubectl rollout status deployment/nginx-deployment

# Display deployment and cluster info
log "Fetching deployment and cluster status..."
kubectl get pods
kubectl get deployment
kubectl get service
kubectl cluster-info
kubectl get pods --all-namespaces

log "Nginx deployment setup complete!"

# Cleanup option
if [ "$1" == "cleanup" ]; then
    log "Deleting Nginx deployment..."
    kubectl delete deployment nginx-deployment
    log "Cleanup complete!"
fi

# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNgnix.sh
# or, curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNgnix.sh


# chmod +x deploy_nginx.sh
# ./deploy_nginx.sh

# ./deploy_nginx.sh cleanup
