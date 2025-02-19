#!/bin/bash

# Function to log messages with spacing
log() {
    echo -e "\n[INFO] $1\n"
}

# Cleanup option - Placed at the beginning to avoid unnecessary execution
if [ "$1" == "cleanup" ]; then
    log "Deleting the Nginx deployment..."
    kubectl delete deployment nginx-deployment
    log "Deleting the Nginx service..."
    kubectl delete service nginx
    log "Cleanup complete!"
    exit 0
fi

# Define YAML file name and URL
YAML_FILE="nginx-deployment.yaml"
YAML_URL="https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml"

# Download YAML file
log "Downloading Nginx deployment YAML..."
curl -s -o "$YAML_FILE" "$YAML_URL"

if [ ! -f "$YAML_FILE" ]; then
    echo -e "\n[ERROR] Failed to download $YAML_FILE. Exiting.\n"
    exit 1
fi

# Apply the YAML configuration
log "Applying the Nginx deployment..."
kubectl apply -f "$YAML_FILE"

# Wait for deployment to be ready
log "Waiting for the deployment to be ready..."
kubectl rollout status deployment/nginx-deployment

# Create a NodePort service for Nginx
log "Creating a NodePort service for Nginx..."
kubectl create service nodeport nginx --tcp=80:80

# Display service information
log "Fetching details of the created Nginx service..."
kubectl get svc nginx

# Display deployment and cluster info
log "Listing all running pods..."
kubectl get pods
sleep 1

log "Listing all deployments..."
kubectl get deployment
sleep 1

log "Listing all services..."
kubectl get service
sleep 1

log "Fetching cluster information..."
kubectl cluster-info
sleep 1

log "Listing all pods across all namespaces..."
kubectl get pods --all-namespaces

log "Nginx deployment setup complete!"

# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O service_deploy.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/ServiceDeployment.sh
# or, curl -o service_deploy.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/ServiceDeployment.sh


# chmod +x service_deploy.sh
# ./service_deploy.sh

# ./service_deploy.sh cleanup