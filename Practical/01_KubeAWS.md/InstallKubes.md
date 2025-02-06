# Install Kubes on AWS

Run the following command on both master and worker node.


`sudo hostnamectl set-hostname master/slave`  
`sudo su`  
`sudo apt-get update && sudo apt-get upgrade -y`  
`sudo reboot -f`  

`sudo swapoff -a`  

```bash
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```

`sudo modprobe overlay`  
`sudo modprobe br_netfilter`  

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```

`sudo sysctl --system`   
`lsmod | grep br_netfilter`   
`lsmod | grep overlay`  

`sudo apt-get update`   
`sudo apt-get install -y ca-certificates curl`  
`sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc`  
`sudo chmod a+r /etc/apt/keyrings/docker.asc`  

`echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`  

`sudo apt-get update`  
`sudo apt-get install -y containerd.io`  

`containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' -e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' | sudo tee /etc/containerd/config.toml`  

`sudo systemctl restart containerd`
`sudo systemctl status containerd`

`sudo apt-get update`  

`sudo apt-get install -y apt-transport-https ca-certificates curl gpg`

`curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg`

`echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list`

`sudo apt-get update`

`sudo apt-get install -y kubelet kubeadm kubectl`

`sudo apt-mark hold kubelet kubeadm kubectl`

## ONLY ON MASTERS NODE
`sudo kubeadm init`  
`mkdir -p "$HOME"/.kube`
`sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config`   
`sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config`


```
kubeadm join 172.31.34.105:6443 --token c8ar5d.p9yvvbfpt4n2z779 \
        --discovery-token-ca-cert-hash sha256:24a3326dcb6a323d0c2e7d06e4996f6cf5c3c9989a7d08eb6947e4c767145566 
```

```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
```


## ONLY on WORKER NODE 

`sudo kubeadm reset pre-flight checks`  
```
sudo kubeadm join 172.31.34.105:6443 --token c8ar5d.p9yvvbfpt4n2z779 \
        --discovery-token-ca-cert-hash sha256:24a3326dcb6a323d0c2e7d06e4996f6cf5c3c9989a7d08eb6947e4c767145566 --cri-socket "unix:///run/containerd/containerd.sock" --v=5
```

You have one master node and two slave nodes. Five replicas of an Nginx pod. 

Deployment YAML file : nginxmicro.yaml

Implement 5 commands