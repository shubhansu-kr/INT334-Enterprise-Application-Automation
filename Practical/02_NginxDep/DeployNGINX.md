# NGINX deployment

You have one master node and two slave nodes. Five replicas of an Nginx pod. 
Deployment YAML file : nginxmicro.yaml
Implement 5 commands

## Steps

Run the following command in master node after master-slave node is ready and connected

1. nano nginx.yaml
   1. Add the requred yaml code to this file
2. kubectl create -f nginx.yaml
3. kubectl apply -f nginx.yaml
4. kubectl get pods
5. kubectl get deployment
6. kubectl get service
7. kubectl cluster -info
8. kubectl get pods --all-namespaces
9. kubectl delete deployment nginx.yaml