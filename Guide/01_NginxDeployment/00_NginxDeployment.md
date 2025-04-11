# NGINX Deployment on Kubernetes

You have:

- **1 Master Node**
- **2 Worker (Slave) Nodes**
- **Objective:** Deploy **5 replicas** of an NGINX pod using a deployment manifest.

> Deployment YAML file: `nginxmicro.yaml`

---

## ✅ Prerequisite

Ensure all nodes (master and workers) are connected and joined to the cluster.

On worker nodes, use the following command to join the master:

```bash
kubeadm join 172.31.86.49:6443 --token g26eqp.2gnntezkupsalp73 \
--discovery-token-ca-cert-hash sha256:7413a042e81aa844635c1877ecfe04de504ac70e24face7fdf47405fed25480b
```

Follow the full cluster setup in [Install Kubes](./../KubernetesSetup/01_MasterSlaveSetupMethod2.md) before proceeding.

---

## 📦 Steps for NGINX Deployment

### 1. Create Deployment YAML

Open a new file using:

```bash
nano nginxmicro.yaml
```

Paste the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 5  # Run 5 replicas
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

Save and exit the file.

---

### 2. Apply Deployment

Create the deployment:

```bash
kubectl create -f nginxmicro.yaml
```

If making changes later, apply again:

```bash
kubectl apply -f nginxmicro.yaml
```

---

## 🔍 Useful kubectl Commands

Run the following commands to inspect your deployment:

1. **List Pods**

   ```bash
   kubectl get pods
   ```

2. **Check Deployment**

   ```bash
   kubectl get deployment
   ```

3. **List Services**

   ```bash
   kubectl get service
   ```

4. **Cluster Info**

   ```bash
   kubectl cluster-info
   ```

5. **Pods in All Namespaces**

   ```bash
   kubectl get pods --all-namespaces
   ```

6. **Delete Deployment**

   ```bash
   kubectl delete deployment nginx-deployment
   ```

---

## 🔗 Reference YAML

The official NGINX deployment file is also available here:

[https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml](https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/nginx-deployment.yaml)

---

---

## 📘 Explanation of Practical

This practical demonstrates how to deploy a multi-replica application (NGINX) using Kubernetes Deployments.

### Key Concepts

- **Deployment Object:** Manages a set of replicated pods. It maintains the desired state (e.g., 5 replicas).
- **Replica:** Multiple instances of the same pod ensure high availability and load balancing.
- **YAML Manifest:** Describes what Kubernetes should create. It includes metadata, pod specs, container details, etc.
- **kubectl Commands:** Used to interact with and inspect the cluster resources.

### What You Learn

- Writing and applying YAML manifests
- Managing deployments
- Inspecting cluster resources
- Understanding Kubernetes object lifecycles

This hands-on exercise is fundamental to mastering Kubernetes deployments and understanding real-world production rollouts.
