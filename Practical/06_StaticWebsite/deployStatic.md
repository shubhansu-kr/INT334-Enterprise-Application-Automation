# Deploy two different static websites

Setup a master - slave node cluster on AWS using the script [SetupMasterSlave](./../../Script/SetupMasterSlave.sh)

Run the following commands to setup the directory and files.

```sh
mkdir site1
mkdir site2
```

`nano site1/index.html`

```html
<!DOCTYPE html>
<html>
<head><title>Site1</title></head>
<body>
<h1>Hello Guys this is site1 - shubhansu-kr</h1>
</body>
</html>
```

`nano site2/index.html`

```html
<!DOCTYPE html>
<html>
<head><title>Site2</title></head>
<body>
<h1>Hello Guys this is site2 - shubhansu-kr</h1>
</body>
</html>
```

```bash
kubectl create configmap site1-html --from-file=index.html=./site1/index.html

kubectl create configmap site2-html --from-file=index.html=./site2/index.html
```

`nano site1-deployment.yaml`

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

`nano site2-deployment.yaml`

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

```bash
kubectl apply -f site1-deployment.yaml
kubectl apply -f site2-deployment.yaml
kubectl get pods
kubectl get svc
kubectl get nodes -o wide
```

=>Browser:-
 Site1: “<http://Node-IP:30001”>
 Site2: “<http://Node-IP:30002”>
