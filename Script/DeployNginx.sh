#!/bin/bash

# Function to log messages with spacing
log() {
    echo -e "\n\n[INFO] $1\n"
}

# Cleanup option
if [ "$1" == "cleanup" ]; then
    log "Deleting the Nginx deployment..."
    kubectl delete deployment nginx-deployment
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

# Display deployment and cluster info with logging
log "Listing all running pods..."
kubectl get pods
sleep 1  # Adding a short pause for better readability

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

# Cleanup option
if [ "$1" == "cleanup" ]; then
    log "Deleting the Nginx deployment..."
    kubectl delete deployment nginx-deployment
    log "Cleanup complete!"
fi


# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh
# or, curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh


# chmod +x deploy_nginx.sh
# ./deploy_nginx.sh

# ./deploy_nginx.sh cleanup

# Tip - Execute
# curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh && chmod +x deploy_nginx.sh && ./deploy_nginx.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh | bash

# Tip - Cleanup
# curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh && chmod +x deploy_nginx.sh && ./deploy_nginx.sh cleanup
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployNginx.sh | bash
