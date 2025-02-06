# NGINX deployment

You have one master node and two slave nodes. Five replicas of an Nginx pod. 
Deployment YAML file : nginxmicro.yaml
Implement 5 commands

## Steps

Run the following command in master node after master-slave node is ready and connected. Follow [Install Kubes](./01_KubeAWS/InstallKubes.md).

```
kubeadm join 172.31.86.49:6443 --token g26eqp.2gnntezkupsalp73 \
        --discovery-token-ca-cert-hash sha256:7413a042e81aa844635c1877ecfe04de504ac70e24face7fdf47405fed25480b
```

1. nano nginx55.yaml
   1. Add the requred yaml code to this file
   2. 
        ```
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: nginx-deployment
        spec:
        selector:
            matchLabels:
            app: nginx
        replicas: 2 # tells deployment to run 2 pods matching the template
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
   
2. kubectl create -f nginx.yaml
3. kubectl apply -f nginx.yaml
4. kubectl get pods
5. kubectl get deployment
6. kubectl get service
7. kubectl cluster-info
8. kubectl get pods --all-namespaces
9. kubectl delete deployment nginx-deployment

```
apiVersion: apps/v1
kind: Deployment
metadata:
name: nginx-deployment
spec:
selector:
    matchLabels:
    app: nginx
replicas: 2 # tells deployment to run 2 pods matching the template
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