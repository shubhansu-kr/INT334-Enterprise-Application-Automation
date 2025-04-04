#!/bin/bash

# Function to log messages
log() {
    echo "[LOG] $(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Stop Splunk service if running
log "Stopping Splunk service if already running..."
sudo /opt/splunk/bin/splunk stop

# Update and upgrade system packages
log "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Download Splunk package
log "Downloading Splunk package..."
wget -O splunk-9.4.1.deb "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

# Verify the downloaded package
log "Verifying the downloaded package..."
ls -lh splunk-9.4.1.deb

# Install Splunk
log "Installing Splunk..."
sudo dpkg -i splunk-9.4.1.deb

# Create required directory if not exists
log "Creating necessary directory for Splunk configuration..."
sudo mkdir -p /opt/splunk/etc/system/local

# Configure Splunk admin credentials
log "Configuring Splunk admin credentials..."
echo -e "[user_info]\nUSERNAME = admin\nPASSWORD = YourStrongPassword" | sudo tee /opt/splunk/etc/system/local/user-seed.conf

# Set permissions for security
log "Setting permissions for Splunk configuration file..."
sudo chown -R splunk:splunk /opt/splunk/etc/system/local/user-seed.conf
sudo chmod 600 /opt/splunk/etc/system/local/user-seed.conf

# Restart Splunk to apply changes and auto-accept license
log "Restarting Splunk service with license agreement..."
sudo /opt/splunk/bin/splunk restart --accept-license

# Fetch public IP using an external service
log "Fetching public IP..."
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

# Display Splunk dashboard URL
log "Splunk Dashboard URL: http://$PUBLIC_IP:8000"

# You can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SplunkDashboard.sh
# or, curl -o splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SplunkDashboard.sh

# chmod +x splunk_dashboard.sh
# ./splunk_dashboard.sh

# Tip 
# curl -o splunk_dashboard.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SplunkDashboard.sh && chmod +x splunk_dashboard.sh && ./splunk_dashboard.sh
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SplunkDashboard.sh | bash
