# Establish Master Node SetUp
# Deploy a service or more. 

<!-- Create a dashboard deployment -->
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard 
> Inplace of cluster Ip in type - add NodePort

kubectl get svc kubernetes-dashboard -n kubernetes-dashboard 
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl get serviceaccount -n kubernetes-dashboard
kubectl -n kubernetes-dashboard create token admin-user

Take this token and go to public ip address of the worker or slave node with the nodeport port number 

eyJhbGciOiJSUzI1NiIsImtpZCI6IlA4TklhQUxMREZIdXlqWG1sMnBDdzZBVXNPcWNWdVB0R3lrV2l2SFNFLUUifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNzQyMzcxNjMzLCJpYXQiOjE3NDIzNjgwMzMsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJhZG1pbi11c2VyIiwidWlkIjoiYjE2YjlkMjEtNTYzNC00Y2UxLThmN2YtZTBhYjUzMTA2MGI2In19LCJuYmYiOjE3NDIzNjgwMzMsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlcm5ldGVzLWRhc2hib2FyZDphZG1pbi11c2VyIn0.hsJVbqwdzjPJa7kVgee6rAdN-J1BXFDNuekqMDzyi7gSHtWqqyz-VWowjq45gr8pW_2qWjRchXK1JxtVlYqq5iEnGFlzG4WdDZ4Lq8F6q4RLHZ_NIPUbf70ybHMvQk1UWb43dWHYwaHljj_7DXbf_v5P_nWps3WGUFuZwTOotbfO5NLt26Tjt1diKKsU4HWOuRjO8ipPrpDSkeMShgCorxI-9nRYsYv8sKLnhSXApFI-cJm9HkcFXdbrWMcKF5nLYKczAXGexp29zEjovdVlBGFqTZuKky9-5EDI2fWPYzFFJY515_vM507Stgh7QTwqV36HWrclcXR3x0wjUfVEow

kubectl get nodes
kubectl get pods

kubectl create clusterrolebinding admin-user-binding     --clusterrole=cluster-admin     --serviceaccount=kubernetes-dashboard:admin-user

---

Custom deployment

kubectl apply -f https://raw.githubusercontent.com/shubhansu-kr/INT334-Enterprise-Application-Automation/refs/heads/master/Static/yaml/kubernetes/dashboard.yaml

kubectl get svc kubernetes-dashboard -n kubernetes-dashboard 
kubectl create serviceaccount admin-user -n kubernetes-dashboard
kubectl get serviceaccount -n kubernetes-dashboard
kubectl -n kubernetes-dashboard create token admin-user

kubectl get nodes
kubectl get pods

kubectl create clusterrolebinding admin-user-binding     --clusterrole=cluster-admin     --serviceaccount=kubernetes-dashboard:admin-user
