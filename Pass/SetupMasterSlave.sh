#!/bin/bash

set -e

# Optional EC2-style prompt simulation
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "172.31.0.1")
PROMPT="root@ip-${PRIVATE_IP//./-}:/home/ubuntu#"

# Colored log functions
log() {
    echo -e "\n\033[1;34m[INFO]\033[0m $1\n"
}

success() {
    echo -e "\n\033[1;32m[SUCCESS]\033[0m $1\n"
}

error() {
    echo -e "\n\033[1;31m[ERROR]\033[0m $1\n"
}

# Execute and display each command
run() {
    echo -e "\n$PROMPT $1"
    eval "$1"
}

# Get node type argument
NODE_TYPE=$1
if [ "$NODE_TYPE" == "master" ]; then
    run "sudo hostnamectl set-hostname master"
elif [ "$NODE_TYPE" == "worker" ]; then
    run "sudo hostnamectl set-hostname worker"
else
    error "Usage: $0 [master|worker]"
    exit 1
fi

log "Updating system..."
run "sudo apt-get update"
run "sudo apt-get upgrade -y"

log "Disabling swap..."
run "sudo swapoff -a"

log "Loading required kernel modules..."
run "echo -e 'overlay\nbr_netfilter' | sudo tee /etc/modules-load.d/k8s.conf"
run "sudo modprobe overlay"
run "sudo modprobe br_netfilter"

log "Setting sysctl params for Kubernetes networking..."
run "echo -e 'net.bridge.bridge-nf-call-iptables = 1\nnet.bridge.bridge-nf-call-ip6tables = 1\nnet.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/k8s.conf"
run "sudo sysctl --system"
run "lsmod | grep br_netfilter"
run "lsmod | grep overlay"

log "Installing container runtime (containerd)..."
run "sudo apt-get install -y ca-certificates curl"
run "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc"
run "sudo chmod a+r /etc/apt/keyrings/docker.asc"
run "echo 'deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \$(. /etc/os-release && echo \"\$VERSION_CODENAME\") stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
run "sudo apt-get update"
run "sudo apt-get install -y containerd.io"

log "Configuring containerd..."
run "containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' -e 's/sandbox_image = \"registry.k8s.io\\/pause:3.6\"/sandbox_image = \"registry.k8s.io\\/pause:3.9\"/' | sudo tee /etc/containerd/config.toml"
run "sudo systemctl restart containerd"
run "sudo systemctl status containerd --no-pager"

log "Installing Kubernetes components..."
run "sudo apt-get install -y apt-transport-https ca-certificates curl gpg"
run "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg"
run "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list"
run "sudo apt-get update"
run "sudo apt-get install -y kubelet kubeadm kubectl"
run "sudo apt-mark hold kubelet kubeadm kubectl"

if [ "$NODE_TYPE" == "master" ]; then
    log "Initializing Kubernetes master node..."
    run "sudo kubeadm init --ignore-preflight-errors=all"

    run "mkdir -p \$HOME/.kube"
    run "sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config"
    run "sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config"

    log "Applying Calico networking..."
    run "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml"

    log "Generating join command..."
    run "kubeadm token create --print-join-command > join-command.sh"
    run "chmod +x join-command.sh"
    success "Master node setup complete! Run 'cat join-command.sh' on the master to get the join command."

elif [ "$NODE_TYPE" == "worker" ]; then
    log "Resetting Kubernetes worker..."
    run "sudo kubeadm reset --force"

    log "Waiting for manual join..."
    success "Worker node setup ready. Please run the join command manually."
fi


# For Master

# chmod +x setup_k8s.sh
# ./setup_k8s.sh master
# cat join-command.sh

# For Worker

# chmod +x setup_k8s.sh
# ./setup_k8s.sh worker
# Copy the join command from the master node and run it manually on the worker node.

# Or you can use wget/curl command to pull the Pass from the GitHub repository and execute it directly.
# wget -O setup_k8s.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SetupMasterSlave.sh
# or, curl -o setup_k8s.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SetupMasterSlave.sh

# sed -i 's/\r$//' setup_k8s.sh
# chmod +x setup_k8s.sh
# ./setup_k8s.sh master or ./setup_k8s.sh worker

# Tip
# curl -o setup_k8s.sh https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SetupMasterSlave.sh && sed -i 's/\r$//' setup_k8s.sh && chmod +x setup_k8s.sh
# ./setup_k8s.sh master  # For Master Node
# ./setup_k8s.sh worker  # For Worker Node

# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SetupMasterSlave.sh | bash -s master
# curl -s https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/master/Pass/SetupMasterSlave.sh | bash -s worker
