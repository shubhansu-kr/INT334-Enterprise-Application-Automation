# Install Kubernetes on AWS

Follow the steps below on **both master and worker nodes**, unless mentioned otherwise.

---

## 1. System Setup (Master and Worker)

```bash
sudo hostnamectl set-hostname master   # or slave
sudo su
sudo apt-get update && sudo apt-get upgrade -y
sudo reboot -f
```

After reboot, run:

```bash
sudo swapoff -a
```

### Load Kernel Modules

```bash
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
```

### Apply Sysctl Settings

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
lsmod | grep br_netfilter
lsmod | grep overlay
```

---

## 2. Install Container Runtime (containerd)

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash
sudo apt-get update
sudo apt-get install -y containerd.io
```

### Configure containerd

```bash
containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' \
-e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' \
| sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl status containerd
```

---

## 3. Install Kubernetes Components

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

## 4. Initialize Master Node (Only on Master)

```bash
sudo kubeadm init
```

### Configure kubectl

```bash
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
```

### Example Join Token (copy this for worker nodes)

```bash
kubeadm join 172.31.34.105:6443 --token c8ar5d.p9yvvbfpt4n2z779 \
--discovery-token-ca-cert-hash sha256:24a3326dcb6a323d0c2e7d06e4996f6cf5c3c9989a7d08eb6947e4c767145566
```

---

## 5. Install Pod Network (Master Node)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
```

---

## 6. Join Worker Node(s)

### Optional Reset (Only if needed)

```bash
sudo kubeadm reset pre-flight checks
```

### Join Cluster

```bash
sudo kubeadm join 172.31.34.105:6443 --token c8ar5d.p9yvvbfpt4n2z779 \
--discovery-token-ca-cert-hash sha256:24a3326dcb6a323d0c2e7d06e4996f6cf5c3c9989a7d08eb6947e4c767145566 \
--cri-socket "unix:///run/containerd/containerd.sock" --v=5
```

---

## 7. Deployment Information

- You now have **1 master node** and **2 worker nodes**.
- Deployment consists of **5 replicas** of an Nginx pod.

### Deployment File

Use the following YAML file: `nginxmicro.yaml`

---

## 8. Run These 5 kubectl Commands

```bash
kubectl get nodes
kubectl get pods -o wide
kubectl describe pod <nginx-pod-name>
kubectl get deployments
kubectl get svc
```

> Replace `<nginx-pod-name>` with the actual name of one of your running pods.

---

---

## 🔍 Explanation of Practical

This practical guides you through setting up a Kubernetes cluster on AWS EC2 instances using `kubeadm`, a tool provided by Kubernetes for bootstrapping clusters.

### Key Components

- **Hostname Configuration:** Sets a clear identity for each node.
- **System Configurations:** Enables required kernel modules and sysctl parameters for Kubernetes networking.
- **containerd Installation:** Installs and configures container runtime (`containerd`), which is essential for running containers inside pods.
- **Kubernetes Installation:** Installs `kubeadm`, `kubectl`, and `kubelet` – the core tools for managing a Kubernetes cluster.
- **Cluster Initialization:** `kubeadm init` sets up the control plane on the master node.
- **Worker Join:** Each worker node is added using the token provided by the master.
- **Network Plugin (Calico):** Calico is used to handle networking between pods.
- **Nginx Deployment:** You deploy an application with 5 Nginx replicas to test that the cluster is working as expected.
- **Command Verification:** Running various `kubectl` commands validates that the cluster is set up properly and the pods are running.

This hands-on exercise gives you fundamental experience with setting up Kubernetes manually, which is helpful before diving into managed services like EKS.
