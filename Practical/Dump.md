1  sudo swapoff -a
    2  cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    3  overlay
    4  br_netfilter
    5  EOF
    6  sudo modprobe overlay
    7  sudo modprobe br_netfilter
    8  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    9  net.bridge.bridge-nf-call-iptables  = 1
   10  net.bridge.bridge-nf-call-ip6tables = 1
   11  net.ipv4.ip_forward                 = 1
   12  EOF
   13  sudo sysctl --system
   14  lsmod | grep br_netfilter
   15  lsmod | grep overlay
   16  sudo apt-get update
   17  sudo apt-get install -y ca-certificates curl
   18  sudo install -m 0755 -d /etc/apt/keyrings
   19  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
   20  sudo chmod a+r /etc/apt/keyrings/docker.asc
   21  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   22  sudo apt-get update
   23  sudo apt-get install -y containerd.io
   24  containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' -e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' | sudo tee /etc/containerd/config.toml
   25  sudo systemctl restart containerd
   26  sudo systemctl status containerd
   27  sudo apt-get update
   28  sudo apt-get install -y apt-transport-https ca-certificates curl gpg
   29  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
   30  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
   31  sudo apt-get update
   32  sudo apt-get install -y kubelet kubeadm kubectl
   33  sudo apt-mark hold kubelet kubeadm kubectl
   34  sudo kubeadm init
   35  mkdir -p "$HOME"/.kube
   36  sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
   37  sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
   38  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
   39  kubeadm token create --print-join-command
   40  kubectl get nodes
   41  nano nginx.yaml
   42  kubectl create -f nginx.yaml
   43  kubectl get po
   44  kubectl get deployment
   45  kubectl get services
   46  kubectl get pods --all-namespaces
   47  kubectl cluster-info
   48  kubectl get rs
   49  kubectl create service nodeport nginx --tcp=80:80
   50  kubectl get svc nginx
   51  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
   52  kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard 
   53  kubectl get svc kubernetes-dashboard -n kubernetes-dashboard 
   54  kubectl create serviceaccount admin-user -n kubernetes-dashboard
   55  kubectl get serviceaccount -n kubernetes-dashboard
   56  kubectl -n kubernetes-dashboard create token admin-user
   57  kubectl get nodes
   58  kubectl get pods
   59  kubectl get deployment
   60  nano nginx123.yaml
   61  kubectl create -f nginx123.yaml
   62  kubectl get po
   63  kubectl get deployment
   64  kubectl get services
   65  kubectl get pods --all-namespaces
   66  kubectl cluster-info
   67  kubectl get rs
   68  kubectl create service nodeport nginx123 --tcp=80:80
   69  kubectl get svc nginx123
   70  sudo cat /etc/kubernetes/admin.conf
   71  kubectl get deployments -n kubernetes-dashboard
   72  kubectl create serviceaccount admin-user -n kubernetes-dashboard
   73  kubectl create clusterrolebinding admin-user-binding     --clusterrole=cluster-admin     --serviceaccount=kubernetes-dashboard:admin-user
   74  kubectl get pos
   75  kubectl get pods
   76  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
   77  kubectl get svc -n kubernetes-dashboard
   78  kubectl proxy
   79  kubectl get svc nginx123
   80  kubectl create service nodeport nginx123 --tcp=80:80
   81  kubectl get svc -n kubernetes-dashboard
   82  kubectl -n kubernetes-dashboard create token admin-user
   83  history