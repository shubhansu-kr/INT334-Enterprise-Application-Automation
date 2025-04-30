#!/bin/bash

set -e

# Optional: Simulated prompt for EC2-style terminal
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "172.31.0.1")
PROMPT="root@ip-${PRIVATE_IP//./-}:/home/ubuntu#"

# Colored logger
log() {
    echo -e "\n\033[1;34m[INFO]\033[0m $1\n"
}

success() {
    echo -e "\n\033[1;32m[SUCCESS]\033[0m $1\n"
}

error() {
    echo -e "\n\033[1;31m[ERROR]\033[0m $1\n"
}

run() {
    echo -e "\n$PROMPT $1"
    eval "$1"
}

# Cleanup block
if [ "$1" == "cleanup" ]; then
    log "Deleting Nginx deployment..."
    run "kubectl delete deployment nginx-deployment"
    log "Deleting Nginx service..."
    run "kubectl delete service nginx"
    success "Cleanup complete!"
    exit 0
fi

# Define YAML file
YAML_FILE="nginx-deployment.yaml"
YAML_URL="https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml"

# Download YAML
log "Downloading Nginx deployment YAML..."
run "curl -s -o $YAML_FILE $YAML_URL"

if [ ! -f "$YAML_FILE" ]; then
    error "Failed to download $YAML_FILE. Exiting."
    exit 1
fi

# Apply deployment
log "Applying Nginx deployment..."
run "kubectl apply -f $YAML_FILE"

# Wait for rollout
log "Waiting for deployment to be ready..."
run "kubectl rollout status deployment/nginx-deployment"

# Create NodePort service
log "Creating NodePort service for Nginx..."
run "kubectl create service nodeport nginx --tcp=80:80"

# Show service info
log "Service info:"
run "kubectl get svc nginx"

# Extract and show public IP and NodePort
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)
NODE_PORT=$(kubectl get svc nginx -o=jsonpath='{.spec.ports[0].nodePort}')
log "You can access Nginx at: http://${PUBLIC_IP}:${NODE_PORT}"

# Cluster information
log "Listing Pods..."
run "kubectl get pods"

log "Listing Deployments..."
run "kubectl get deployment"

log "Listing Services..."
run "kubectl get service"

log "Fetching Cluster Info..."
run "kubectl cluster-info"

log "Listing all Pods across namespaces..."
run "kubectl get pods --all-namespaces"

success "Nginx deployment setup complete!"


# You can use wget/curl command to pull the Pass from the GitHub repository and execute it directly.
# wget -O service_deploy.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/ServiceDeployment.sh
# or, curl -o service_deploy.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/ServiceDeployment.sh


# chmod +x service_deploy.sh
# ./service_deploy.sh

# ./service_deploy.sh cleanup

# Tip 
# curl -o service_deploy.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/ServiceDeployment.sh && chmod +x service_deploy.sh && ./service_deploy.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/ServiceDeployment.sh | bash

