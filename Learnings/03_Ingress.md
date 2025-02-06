# Ingress 

It is an API object in K8s. 
- It exposes HTTP & HTTPS routes from outside the cluster
- Path based and Host based
- Load balancing and SSL Termination
- Ingress Controller -> K8's brain -> Rules, logic and decision

- Services : ClusterIP, Nodeport, LoadBalancer

Path based ingress -> The http req is redirected to different services based on the path of the req. Course req goes to service 1, home req goes to service 2 and so on..

Host based ingress -> 
SSL Termination ->

Arch : 

User -> http://mycourse.com -> service -> Ingress controller

Ingress controller -> INgress resource -> service -> different pods

---

# Ingress

Kuberneters ingress is a collection of routing rules that govern how external users access services running in a Kubernetes cluster

                        Ingress
                        /      \     
        Intellipat.com/image    Intellipat.com/Video
        Service A               Service B

The req is routed to different service based on the user's request. Here req for image is directed to service A and req for video is directed to service B

                        User
                          |
                    Ingress Service 
                       (Node Port)
                          |
                    Ingress Controller
                    /               \
        Intellipat.com/video        Intellipat.com/image
            Service A                   Service B
            (Cluster Ip)                (Cluster Ip)
        /   |    |     \            /   |     |     \
    Pod-1 Pod-2 Pod-3 Pod-4     Pod-1 Pod-2 Pod-3 Pod-4
            (Replicas)                  (Replicas)

User makes a request to the service. Which is passed on to the ingress controller. The controller decides the correct service for the request. The call reaches the Service which uses it's pods to serve the request.


Different types of Ingress controller 
1. Nginx Controller
2. Istio Ingress
3. APache APISIX
4. Critix Ingress
5. Contour Controller
6. HA Proxy Ingress
7. Voyager
8. Traefik
9. Wallarm
