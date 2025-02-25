#!/bin/bash

# Function to log messages
log() {
    echo "[INFO] $1"
}

# Set hostname (Modify as needed)
NODE_TYPE=$1
if [ "$NODE_TYPE" == "master" ]; then
    sudo hostnamectl set-hostname master
elif [ "$NODE_TYPE" == "worker" ]; then
    sudo hostnamectl set-hostname worker
else
    echo "Usage: $0 [master|worker]"
    exit 1
fi

# Update system
log "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

# Disable swap
log "Disabling swap..."
sudo swapoff -a

# Load necessary kernel modules
log "Loading required kernel modules..."
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set sysctl parameters
log "Configuring networking..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
lsmod | grep br_netfilter
lsmod | grep overlay

# Install container runtime (containerd)
log "Installing container runtime..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add Docker GPG key and repository
log "Adding Docker repository..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

# Configure containerd
log "Configuring containerd..."
containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' -e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl status containerd --no-pager

# Install Kubernetes packages
log "Installing Kubernetes components..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Initialize the Kubernetes cluster (Only on master node)
if [ "$NODE_TYPE" == "master" ]; then
    log "Initializing Kubernetes master node..."
    sudo kubeadm init --ignore-preflight-errors=all

    mkdir -p "$HOME/.kube"
    sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
    sudo chown "$(id -u)":"$(id -g)" "$HOME/.kube/config"

    # Apply Calico network plugin
    log "Applying Calico networking..."
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

    log "Master node setup complete!"
    log "To join worker nodes, use the following command:"
    kubeadm token create --print-join-command > join-command.sh
    chmod +x join-command.sh
    log "Run 'cat join-command.sh' to see the join command."
elif [ "$NODE_TYPE" == "worker" ]; then
    log "Resetting Kubernetes on worker node..."
    sudo kubeadm reset --force

    log "Joining the Kubernetes cluster..."
    # Run the join command (manual step)
    log "Run the join command from the master node."
fi

# For Master

# chmod +x setup_k8s.sh
# ./setup_k8s.sh master
# cat join-command.sh

# For Worker

# chmod +x setup_k8s.sh
# ./setup_k8s.sh worker
# Copy the join command from the master node and run it manually on the worker node.

# Or you can use wget/curl command to pull the script from the GitHub repository and execute it directly.
# wget -O setup_k8s.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SetupMasterSlave.sh
# or, curl -o setup_k8s.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Script/SetupMasterSlave.sh

# sed -i 's/\r$//' setup_k8s.sh
# chmod +x setup_k8s.sh
# ./setup_k8s.sh master or ./setup_k8s.sh worker