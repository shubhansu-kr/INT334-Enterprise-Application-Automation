Ingress On Kubernetes:

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

Load Balancer

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/refs/heads/main/deploy/static/provider/baremetal/deploy.yaml

NodePort

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml


Step 3 - Validate the NGINX Ingress Controller

kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx

kubectl get pods -n ingress-nginx 

kubectl get svc -n ingress-nginx 

Create nano file:

nano ingress.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world
spec:
  rules:
    - host: hello-world.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: hello-world
                port:
                  number: 80

kubectl create -f ingress.yaml

kubectl get svc -n ingress-nginx


---

Yes! The YAML code I provided can go in **a single file**. The `---` is **a valid separator** in YAML, which allows you to define multiple resources in **one file**.  

### **How It Works**
- The **first part** defines a `Deployment` for the `hello-world` pod.
- The **second part** defines a `Service` to expose it.

### **How to Use It**
1. **Create a file** (e.g., `hello-world.yaml`):
   ```sh
   nano hello-world.yaml
   ```
2. **Paste this content**:
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
               - "-text=Hello from Kubernetes!"
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

3. **Apply it to the cluster**:
   ```sh
   kubectl apply -f hello-world.yaml
   ```

4. **Verify the deployment and service**:
   ```sh
   kubectl get pods
   kubectl get svc
   ```

Now your `hello-world` service should be running and accessible via the Ingress! 🚀


I get your frustration. You just wanted a simple ingress setup, and it turned into a headache. Let’s fix it **quickly and cleanly** from scratch.  

---

### **🚀 Minimal Working Ingress Setup**
Here’s a step-by-step approach to expose a simple service using **Ingress** on your cluster.

---

### **1️⃣ Deploy a Simple Web App**
We’ll use **`nginx`** because it’s lightweight and has a shell for debugging.

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
        image: nginx
        ports:
        - containerPort: 80
```
Apply this:
```sh
kubectl apply -f hello-world.yaml
```

---

### **2️⃣ Expose the App as a Service**
Now, expose it with a **ClusterIP** service.

```yaml
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
Apply it:
```sh
kubectl apply -f hello-world-service.yaml
```

---

### **3️⃣ Deploy an Ingress Resource**
Now, create an **Ingress** rule that routes external traffic to our service.

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
Apply it:
```sh
kubectl apply -f hello-world-ingress.yaml
```

---

### **4️⃣ Ensure an Ingress Controller Exists**
Check if an ingress controller is running:
```sh
kubectl get pods -n ingress-nginx
```
If not, install one:
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

---

### **5️⃣ Test Your Ingress**
Find the **external IP**:
```sh
kubectl get ingress hello-world-ingress
```
If it's pending, use:
```sh
kubectl get svc -n ingress-nginx
```
Now, test it:
```sh
curl -H "Host: hello.local" http://<INGRESS_IP>
```

---

### **🔥 TL;DR**
1. **Deploy an `nginx` app** ✅  
2. **Expose it as a ClusterIP service** ✅  
3. **Use Ingress to route external traffic** ✅  
4. **Ensure an ingress controller is running** ✅  
5. **Test with curl** ✅  

If this doesn’t work, tell me **exactly where it fails**, and I’ll **fix it fast.** 🚀