# Deployment of Kubernetes Service

## 🧩 Objective

Create a **Kubernetes NodePort Service** for an NGINX deployment running in a cluster with:

- **1 Master Node**
- **1 Worker Node**

---

## ⚙️ Steps

### 1. Ensure Cluster is Ready

Make sure your master and worker nodes are connected and the NGINX deployment is running with at least one replica.

If not already done, refer to the previous [NGINX Deployment Guide](./../01_NginxDeployment/00_NginxDeployment.md) and make sure the pods are up and running.

---

### 2. Create a NodePort Service for NGINX

Run the following on the **master node**:

```bash
kubectl create service nodeport nginx --tcp=80:80
```

This creates a `NodePort` type service named `nginx` which exposes port 80 of the pod on a dynamic high port on the worker node.

---

### 3. Verify the Service

Check the assigned **NodePort** using:

```bash
kubectl get svc nginx
```

Example output:

```bash
NAME    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx   NodePort   10.99.222.195   <none>        80:30399/TCP   11m
```

In this example, port `30399` is exposed.

---

### 4. Access the NGINX Website

Open a browser and go to:

```url
http://<WORKER_PUBLIC_IP>:30399
```

> Replace `<WORKER_PUBLIC_IP>` with your actual worker node's **public IP address**, and `30399` with the port from your `kubectl get svc` output.

You should see the **default NGINX welcome page**, confirming your service is working.

---

## 🧠 Explanation

This practical demonstrates how to expose a Kubernetes deployment to the outside world using a **NodePort Service**.

### Key Concepts

- **Service (NodePort):** Makes a pod accessible from outside the cluster by exposing it on a static port on all cluster nodes.
- **ClusterIP:** Internal IP assigned to the service within the cluster.
- **Pod-to-Service Routing:** The service forwards traffic to one or more pods using label selectors.

### What You Learn

- Creating services to expose pods
- Understanding how traffic enters a Kubernetes cluster
- Basic networking and service discovery in Kubernetes

This is a foundational concept for making applications accessible to users outside the Kubernetes cluster.
