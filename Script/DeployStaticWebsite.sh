#!/bin/bash

# Define variables
REPO_URL="https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Static"
SITE1_HTML="$REPO_URL/html/Page1.html"
SITE2_HTML="$REPO_URL/html/Page2.html"
SITE1_YAML="$REPO_URL/yaml/site/00_Site1deployment.yaml"
SITE2_YAML="$REPO_URL/yaml/site/01_Site2deployment.yaml"

# Define colors for logs
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# Custom logging functions
log() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

# Start deployment
echo ""
log "Starting static website deployment in Kubernetes..."
echo ""

# Create directories for site files
log "Creating directories for site files..."
mkdir -p site1 site2
success "Directories created successfully!"
echo ""

# Download HTML files
log "Downloading HTML files from GitHub..."
curl -s -o site1/index.html "$SITE1_HTML"
curl -s -o site2/index.html "$SITE2_HTML"
success "HTML files downloaded successfully!"
echo ""

# Create Kubernetes ConfigMaps
log "Creating ConfigMaps for static sites..."
kubectl create configmap site1-html --from-file=index.html=site1/index.html --dry-run=client -o yaml | kubectl apply -f -
kubectl create configmap site2-html --from-file=index.html=site2/index.html --dry-run=client -o yaml | kubectl apply -f -
success "ConfigMaps created successfully!"
echo ""

# Download and apply Kubernetes deployment files
log "Downloading Kubernetes deployment YAML files..."
curl -s -o site1-deployment.yaml "$SITE1_YAML"
curl -s -o site2-deployment.yaml "$SITE2_YAML"
success "YAML files downloaded successfully!"
echo ""

# Apply deployments
log "Applying deployments to Kubernetes..."
kubectl apply -f site1-deployment.yaml
kubectl apply -f site2-deployment.yaml
success "Deployments applied successfully!"
echo ""

# Wait for pods to be ready
log "Ensuring Site1 pod is running..."
until kubectl get pods -l app=site1 --field-selector=status.phase=Running &> /dev/null; do
    sleep 2
    echo -n "."
done
success "Site1 pod is running!"
echo ""

log "Ensuring Site2 pod is running..."
until kubectl get pods -l app=site2 --field-selector=status.phase=Running &> /dev/null; do
    sleep 2
    echo -n "."
done
success "Site2 pod is running!"
echo ""

# Fetch public IP
log "Fetching public IP..."
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)
if [ -z "$PUBLIC_IP" ]; then
    error "Failed to fetch public IP!"
    exit 1
fi
success "Public IP detected: $PUBLIC_IP"
echo ""

# Display service details
log "Fetching Kubernetes service details..."
kubectl get pods
kubectl get svc
echo ""

# Print access links
log "Deployment completed successfully! Access the websites at:"
echo -e "${GREEN}Site1:${RESET} http://$PUBLIC_IP:30001"
echo -e "${GREEN}Site2:${RESET} http://$PUBLIC_IP:30002"
echo ""

# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployStaticWebsite.sh
# or, curl -o deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployStaticWebsite.sh

# chmod +x deploy_static_webpage.sh
# ./deploy_static_webpage.sh

# Tip
# curl -o deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployStaticWebsite.sh && chmod +x deploy_static_webpage.sh && ./deploy_static_webpage.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/DeployStaticWebsite.sh | bash
