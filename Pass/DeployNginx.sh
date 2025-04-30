#!/bin/bash

# Fetch EC2 private IP once
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PROMPT="root@ip-$PRIVATE_IP:/home/ubuntu#"

# Function to simulate terminal command
run() {
    echo -e "\n$PROMPT $1"
    eval "$1"
}

# Function to log messages
log() {
    echo -e "\n[INFO] $1\n"
}

# Cleanup if requested
if [ "$1" == "cleanup" ]; then
    log "Deleting the Nginx deployment..."
    run "kubectl delete deployment nginx-deployment"
    log "Cleanup complete!"
    exit 0
fi

# Define variables
YAML_FILE="nginx-deployment.yaml"
YAML_URL="https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml"

# Download YAML
log "Downloading Nginx deployment YAML..."
run "curl -s -o $YAML_FILE $YAML_URL"

if [ ! -f "$YAML_FILE" ]; then
    echo -e "\n[ERROR] Failed to download $YAML_FILE. Exiting.\n"
    exit 1
fi

# Apply deployment
log "Applying the Nginx deployment..."
run "kubectl apply -f $YAML_FILE"

# Wait for rollout
log "Waiting for the deployment to be ready..."
run "kubectl rollout status deployment/nginx-deployment"

# Cluster inspection
log "Listing all running pods..."
run "kubectl get pods"
sleep 1

log "Listing all deployments..."
run "kubectl get deployment"
sleep 1

log "Listing all services..."
run "kubectl get service"
sleep 1

log "Fetching cluster information..."
run "kubectl cluster-info"
sleep 1

log "Listing all pods across all namespaces..."
run "kubectl get pods --all-namespaces"

log "Nginx deployment setup complete!"



# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh
# or, curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh


# chmod +x deploy_nginx.sh
# ./deploy_nginx.sh

# ./deploy_nginx.sh cleanup

# Tip - Execute
# curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh && chmod +x deploy_nginx.sh && ./deploy_nginx.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh | bash

# Tip - Cleanup
# curl -o deploy_nginx.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh && chmod +x deploy_nginx.sh && ./deploy_nginx.sh cleanup
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployNginx.sh | bash
