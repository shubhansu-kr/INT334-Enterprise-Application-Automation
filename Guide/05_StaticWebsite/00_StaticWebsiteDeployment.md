# **Static Website Deployment on Kubernetes (Site1 & Site2)**

## **Step 1: Cluster Setup**

Ensure you have a master-slave Kubernetes cluster running. If not already set up, use:

```sh
./../../Script/SetupMasterSlave.sh
```

This script should provision a cluster with 1 master and 1 worker node on AWS.

---

## **Step 2: Prepare Website Files**

```sh
mkdir site1
mkdir site2
```

Create HTML files for each site:

```sh
nano site1/index.html
```

```html
<!DOCTYPE html>
<html>
<head><title>Site1</title></head>
<body>
<h1>Hello Guys this is site1 - shubhansu-kr</h1>
</body>
</html>
```

```sh
nano site2/index.html
```

```html
<!DOCTYPE html>
<html>
<head><title>Site2</title></head>
<body>
<h1>Hello Guys this is site2 - shubhansu-kr</h1>
</body>
</html>
```

---

## **Step 3: Create ConfigMaps from HTML Files**

```sh
kubectl create configmap site1-html --from-file=index.html=./site1/index.html
kubectl create configmap site2-html --from-file=index.html=./site2/index.html
```

This maps each `index.html` file to a ConfigMap so that it can be mounted inside containers.

---

## **Step 4: Create Deployments and Services**

### `site1-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: site1-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: site1
  template:
    metadata:
      labels:
        app: site1
    spec:
      containers:
      - name: site1
        image: nginx:alpine
        volumeMounts:
        - name: site1-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: site1-html
        configMap:
          name: site1-html
---
apiVersion: v1
kind: Service
metadata:
  name: site1-service
spec:
  type: NodePort
  selector:
    app: site1
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30001
```

### `site2-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: site2-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: site2
  template:
    metadata:
      labels:
        app: site2
    spec:
      containers:
      - name: site2
        image: nginx:alpine
        volumeMounts:
        - name: site2-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: site2-html
        configMap:
          name: site2-html
---
apiVersion: v1
kind: Service
metadata:
  name: site2-service
spec:
  type: NodePort
  selector:
    app: site2
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30002
```

Apply both YAML files:

```sh
kubectl apply -f site1-deployment.yaml
kubectl apply -f site2-deployment.yaml
```

---

## **Step 5: Verify Everything**

```sh
kubectl get pods
kubectl get svc
kubectl get nodes -o wide
```

---

## **Step 6: Access in Browser**

Find your **Node IP** from `kubectl get nodes -o wide`. Open these in your browser:

- **Site 1**: `http://<Node-IP>:30001`
- **Site 2**: `http://<Node-IP>:30002`

---

## **Explanation**

This setup demonstrates how to host static content using Kubernetes:

### **What’s Happening**

- You mount `index.html` files into `nginx` containers using **ConfigMaps**.
- Each website is deployed as a **Deployment** with 1 replica.
- A **NodePort** service exposes each site to the internet via the worker node’s IP.
- The custom HTML replaces the default NGINX welcome page.

### **Why It’s Useful**

- Teaches the concept of **ConfigMap volume mounting**.
- Shows how to expose workloads externally using **NodePort**.
- Simulates real-world hosting of multiple applications on a single cluster.

You can later extend this setup to use **Ingress** to access both sites under different paths or subdomains instead of NodePorts.
