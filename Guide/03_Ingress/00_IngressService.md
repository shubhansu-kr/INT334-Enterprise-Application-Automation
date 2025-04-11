# **Kubernetes Ingress Practical**

> Set up Ingress on a Kubernetes cluster to expose a service externally using a domain-like hostname.

---

## **1. Install Ingress Controller**

> Apply the Ingress-NGINX controller manifest.

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

> Wait for the pods to be ready:

```sh
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

---

## **2. Deploy the Web App**

### Create a file: `hello-world.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
        - name: hello-world
          image: hashicorp/http-echo
          args:
            - "-text=Hello from Kubernetes Ingress!"
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  selector:
    app: hello-world
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

### Apply the YAML

```sh
kubectl apply -f hello-world.yaml
```

---

## **3. Create the Ingress Resource**

### Create a file: `hello-world-ingress.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: hello.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-world
                port:
                  number: 80
```

### Apply it

```sh
kubectl apply -f hello-world-ingress.yaml
```

---

## **4. Test the Ingress**

### Get the Ingress Controller IP

```sh
kubectl get svc -n ingress-nginx
```

Look for the `EXTERNAL-IP` or `CLUSTER-IP` of the `ingress-nginx-controller` service. If you are on local setup like Minikube or a VM, use the **NodePort** or **host IP**.

### Add to `/etc/hosts` on your local system

```sh
sudo nano /etc/hosts
```

Add:

```text
<EXTERNAL-IP>    hello.local
```

Replace `<EXTERNAL-IP>` with the IP you got from `kubectl get svc`.

### Test with Curl

```sh
curl http://hello.local
```

You should see:

```text
Hello from Kubernetes Ingress!
```

---

## ✅ Verification Commands

```sh
kubectl get pods
kubectl get svc
kubectl get ingress
kubectl describe ingress hello-world-ingress
kubectl logs <nginx-ingress-pod-name> -n ingress-nginx
```

---

## Explanation

This practical demonstrates how to expose a Kubernetes application using **Ingress**:

- We use **HashiCorp's `http-echo` image** to simulate a web app.
- A **ClusterIP service** is created to expose the app internally.
- An **Ingress rule** is created with a custom domain (`hello.local`) to route requests.
- The **NGINX Ingress Controller** is deployed to handle HTTP routing.
- Finally, we access the service externally by mapping the domain to the controller's IP.

This approach is **portable** and works across different cloud environments and local clusters (e.g., Minikube, AWS EC2, etc.).

Let me know if you want to test this on EC2 or Minikube — I’ll tailor the steps for that environment.
