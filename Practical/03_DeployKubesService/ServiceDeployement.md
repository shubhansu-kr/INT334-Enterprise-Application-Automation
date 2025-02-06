# Deployment of Kubernetes Service

Create a master slave cluster with 1 master and 1 worker node

In the masters node. 

```
kubectl create service nodeport nginx --tcp=80:80
kubectl get svc nginx - Remember the prot from the output
GO to the public ip address of the worker node: port from the output. NGINX website should be visible there.
```

```
root@master:/home/ubuntu# kubectl create service nodeport nginx --tcp=80:80
service/nginx created
root@master:/home/ubuntu# kubectl get svc nginx
NAME    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx   NodePort   10.99.222.195   <none>        80:30399/TCP   11m
root@master:/home/ubuntu# 
```