# History of Kubernetes Development

- Kubernetes was originated at google and was developed by enginners like Joe Beda, Brendan Burns and Craig McLuckie. Later, Brian Grant and Tim Hockin joined the project.
- It was inspired by Borg, Google's proprietary container orchestration platform and a later version fo Borg called Omega.

- Kubernetes was oficially released as an opensource prject in June 2014. 
- Google donated Kubernetes to the Cloud Native Computing Foundation (CNCF) upon its founding in 2015

- Kubernetes has become the de facto standard for container orchestration. 
- Major cloud providers like AWS, Azure and Google Cloud offer managed Kubernetes such as Amazon EKS, Azure AKS and Google Kubernetes Engine (GKE).

Why Golang was chosen
- Concurrency: Essential for handling multiple container and nodes
- Simplicity
- Performance
- Networking

Kubernetes Ecosystem
- Core Component 
  - API Server
  - Scheduler
  - Controller Manager
  - Kubelet
  - Kube-proxy
- Key Tools
  - Minikube
  - Helm
- Managed Services
- Extensibility
  - K8s supports Custom Resource Definitions (CRDs)
  - Popular Addons - Prometheus (Monitoring), Fluentd (Logging) and services meshes like Istio

Major Milestones
- 2014: Encubation
- 2015: Adopted by CNCF
- 2018
- Present

API : Application Programmable Interface

Kubernetes : (K8s)
- Automated Scheduling
- Self healing Capabilities
- Automated rollbacks and rollouts
- Horizontal scaling and load balancing

K8s Architecture 
MasterNode -> SlaveNode, SlaveNode, SlaveNode
Master Node | Worker Node

Master Node (K8s)
- Accessed through CLI, GUI via API
- API Server interacts with 
  - Store etcd
  - Scheduler
  - Controller

Slave Node (K8s)
- Componenets of worker node
  - Kubelet
  - Container Runtime (Docker)
  - Network Proxy (Kube-proxy) - Interact with internet
  - Pod - Smallest deployable unit
  - Optional Addons

Complete Architect of K8s
- Developer interacts with the master node via API
- Master Node creates and manages Worker Nodes
- User's request are served by master's node

Components of Master Node

1. ETCD: It is a highly available distributed key-value store, which is used to store cluster wide secrets. It is only accessible by the kubernetes API server, as it has sensitive information 
    - Key-Value store
    - Stores cluster wide secrets 
    - Only accessible through API server
    - Has Sensitive information
2. Scheduler: The scheduler takes care of scheduling of all processes and the dynamic resource management and manages present and future events on the cluster.
    - Process Scheduling
    - Dynamic Resource Management
    - Present and Future event on the cluster
3. API Server: It exposes kubernetes API. Kubernetes API is the frontend for the kubernetes control plane and is used to deploy and execute all operations in Kubernetes.
4. Controller Manager: The controller manager runs all controllers on the kubernetes cluster. Although each controller is a separate process, to reduce complexity, all controllers are compliled into a single process. They are as follows : 
    - Node Controller
    - Replication Controller
    - Endpoints Controller
    - Service Accounts 
    - Token Controllers

Component of Slave Node (Worker Node): 

1. Kubelet: Kubelet takes the specification from the API server and ensures the application is running according to the specifications which are mentioned. Each node has its own kubelet service. 
2. Kube-Proxy: The proxy services runs on each node and helps in making services available to the external host. It helps in connection forwarding to the correct resources. It is also capable of doing primitive load balancing. 
3. Pod: A pod is the smallest and the most elementary execution unit of kubernetes. 
   1. Pods are also the simplest unit in the kubernetes object model whichyou can create and deploy
   2. Pods represent the processes that are running on the cluster
   3. Every pod has different phases that define where it lies in its life cycle. this phase of a pod is not actually a comprehensive roll up of the pod's state or containers. The phase is just meant ot depict hte condition of the pod in the current timestamp.