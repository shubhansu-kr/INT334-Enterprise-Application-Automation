#!/bin/bash

# Fetch EC2 private IP
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
PROMPT="root@ip-$PRIVATE_IP:/home/ubuntu#"

# Define URLs
REPO_URL="https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Static"
SITE1_HTML="$REPO_URL/html/Page1.html"
SITE2_HTML="$REPO_URL/html/Page2.html"
SITE1_YAML="$REPO_URL/yaml/site/00_Site1deployment.yaml"
SITE2_YAML="$REPO_URL/yaml/site/01_Site2deployment.yaml"

# Define colors
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# Logging functions
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

# Simulate terminal command
run() {
    echo -e "\n$PROMPT $1"
    eval "$1"
}

echo ""
log "Starting static website deployment in Kubernetes..."

log "Creating directories for site files..."
run "mkdir -p site1 site2"
success "Directories created successfully!"

log "Downloading HTML files from GitHub..."
run "curl -s -o site1/index.html $SITE1_HTML"
run "curl -s -o site2/index.html $SITE2_HTML"
success "HTML files downloaded successfully!"

log "Creating ConfigMaps for static sites..."
run "kubectl create configmap site1-html --from-file=index.html=site1/index.html --dry-run=client -o yaml | kubectl apply -f -"
run "kubectl create configmap site2-html --from-file=index.html=site2/index.html --dry-run=client -o yaml | kubectl apply -f -"
success "ConfigMaps created successfully!"

log "Downloading Kubernetes deployment YAML files..."
run "curl -s -o site1-deployment.yaml $SITE1_YAML"
run "curl -s -o site2-deployment.yaml $SITE2_YAML"
success "YAML files downloaded successfully!"

log "Applying deployments to Kubernetes..."
run "kubectl apply -f site1-deployment.yaml"
run "kubectl apply -f site2-deployment.yaml"
success "Deployments applied successfully!"

log "Ensuring Site1 pod is running..."
until kubectl get pods -l app=site1 --field-selector=status.phase=Running &> /dev/null; do
    echo -n "."
    sleep 2
done
success "Site1 pod is running!"

log "Ensuring Site2 pod is running..."
until kubectl get pods -l app=site2 --field-selector=status.phase=Running &> /dev/null; do
    echo -n "."
    sleep 2
done
success "Site2 pod is running!"

log "Fetching public IP..."
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)
if [ -z "$PUBLIC_IP" ]; then
    error "Failed to fetch public IP!"
    exit 1
fi
success "Public IP detected: $PUBLIC_IP"

log "Fetching Kubernetes service details..."
run "kubectl get pods"
run "kubectl get svc"

log "Deployment completed successfully! Access the websites at:"
echo -e "${GREEN}Site1:${RESET} http://$PUBLIC_IP:30001"
echo -e "${GREEN}Site2:${RESET} http://$PUBLIC_IP:30002"
echo ""


# You can use wget/curl command to pull the Pass from the GitHub repository and execute it directly.
# wget -O deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployStaticWebsite.sh
# or, curl -o deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployStaticWebsite.sh

# chmod +x deploy_static_webpage.sh
# ./deploy_static_webpage.sh

# Tip
# curl -o deploy_static_webpage.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployStaticWebsite.sh && chmod +x deploy_static_webpage.sh && ./deploy_static_webpage.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/DeployStaticWebsite.sh | bash
