#!/bin/bash

set -e

# Fetch EC2-like private IP for simulated prompt
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "172.31.0.1")
PROMPT="root@ip-${PRIVATE_IP//./-}:/home/ubuntu#"

# Logging and helper functions
log() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

separator() {
    echo -e "\n------------------------------------------------------\n"
}

run() {
    echo -e "\n$PROMPT $1"
    eval "$1"
}

# Step 1: Apply dashboard manifest
separator
log "Applying Kubernetes Dashboard manifest..."
run "kubectl apply -f https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/refs/heads/master/Static/yaml/kubernetes/dashboard.yaml"
success "Dashboard manifest applied."

# Step 2: Create admin user and role binding
separator
log "Creating admin service account and binding cluster role..."
run "kubectl create serviceaccount admin-user -n kubernetes-dashboard || true"
run "kubectl create clusterrolebinding admin-user-binding --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:admin-user || true"
success "Admin user and role binding set."

# Step 3: Fetch public IP
separator
log "Fetching public IP..."
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)
if [ -z "$PUBLIC_IP" ]; then
    error "Failed to fetch public IP!"
    exit 1
fi
log "Public IP fetched: $PUBLIC_IP"
success "Public IP detection complete."

# Step 4: Wait for dashboard service
separator
log "Waiting for dashboard service to become ready..."
run "kubectl wait --for=condition=available --timeout=60s deployment/kubernetes-dashboard -n kubernetes-dashboard || true"
sleep 3

log "Getting NodePort for kubernetes-dashboard service..."
NODE_PORT=$(kubectl get svc kubernetes-dashboard -n kubernetes-dashboard -o=jsonpath='{.spec.ports[0].nodePort}')
if [ -z "$NODE_PORT" ]; then
    error "Failed to retrieve NodePort!"
    exit 1
fi
log "NodePort fetched: $NODE_PORT"
success "Service is available at NodePort $NODE_PORT."

# Step 5: Get access token
separator
log "Fetching access token..."
TOKEN=$(kubectl -n kubernetes-dashboard create token admin-user)
TOKEN_FILE="dashboard_token.txt"
echo "$TOKEN" > "$TOKEN_FILE"
log "Token saved to: $TOKEN_FILE"
success "Token retrieval complete."

# Step 6: Output dashboard info
separator
DASHBOARD_URL="https://${PUBLIC_IP}:${NODE_PORT}"
log "Kubernetes Dashboard URL:"
echo -e "\n\033[1;32m$DASHBOARD_URL\033[0m\n"

# Step 7: User prompt
separator
echo "What would you like to do?"
select opt in "Show token" "Exit"; do
    case $opt in
        "Show token")
            separator
            log "Access Token:"
            cat "$TOKEN_FILE"
            break
            ;;
        "Exit")
            echo "Exiting."
            break
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
done


# You can use wget/curl command to pull the Pass from the GitHub repository and execute it directly.
# wget -O kubernetes_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh
# or, curl -o kubernetes_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh


# chmod +x kubernetes_dashboard.sh
# ./kubernetes_dashboard.sh

# Tip - Execute
# curl -o kubernetes_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh && chmod +x kubernetes_dashboard.sh && ./kubernetes_dashboard.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh | bash

# Tip - Cleanup
# curl -o kubernetes_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh && chmod +x kubernetes_dashboard.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/KubernetesDashboard.sh | bash
