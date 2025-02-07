Ingress On Kubernetes:

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml

Load Balancer

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml

NodePort

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml


Step 3 - Validate the NGINX Ingress Controller

kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx

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
