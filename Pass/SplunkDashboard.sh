#!/bin/bash

set -e

# Simulated EC2-style prompt
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "172.31.0.1")
PROMPT="root@ip-${PRIVATE_IP//./-}:/home/ubuntu#"

# Logger functions
log() {
    echo -e "\n\033[1;34m[INFO $(date +'%Y-%m-%d %H:%M:%S')]\033[0m $1\n"
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

# Stop Splunk if running
log "Stopping Splunk service if already running..."
run "sudo /opt/splunk/bin/splunk stop || true"

# Update and upgrade system packages
log "Updating and upgrading system packages..."
run "sudo apt update && sudo apt upgrade -y"

# Download Splunk package
log "Downloading Splunk package..."
run "wget -O splunk-9.4.1.deb https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

# Verify the downloaded package
log "Verifying the downloaded Splunk package..."
run "ls -lh splunk-9.4.1.deb"

# Install Splunk
log "Installing Splunk..."
run "sudo dpkg -i splunk-9.4.1.deb"

# Create necessary configuration directory
log "Creating configuration directory..."
run "sudo mkdir -p /opt/splunk/etc/system/local"

# Set admin credentials
log "Configuring Splunk admin credentials..."
run "echo -e '[user_info]\nUSERNAME = admin\nPASSWORD = YourStrongPassword' | sudo tee /opt/splunk/etc/system/local/user-seed.conf"

# Set ownership and permissions
log "Setting secure permissions on user-seed.conf..."
run "sudo chown -R splunk:splunk /opt/splunk/etc/system/local/user-seed.conf"
run "sudo chmod 600 /opt/splunk/etc/system/local/user-seed.conf"

# Restart Splunk and accept license
log "Restarting Splunk service with license agreement..."
run "sudo /opt/splunk/bin/splunk restart --accept-license"

# Get public IP
log "Fetching public IP..."
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

# Show dashboard access URL
log "Splunk Dashboard URL: http://${PUBLIC_IP}:8000"

success "Splunk setup complete!"

# You can use wget/curl command to pull the Pass from the GitHub repository and execute it directly.
# wget -O splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SplunkDashboard.sh
# or, curl -o splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SplunkDashboard.sh

# chmod +x splunk_dashboard.sh
# ./splunk_dashboard.sh

# Tip 
# curl -o splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SplunkDashboard.sh && chmod +x splunk_dashboard.sh && ./splunk_dashboard.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SplunkDashboard.sh | bash
