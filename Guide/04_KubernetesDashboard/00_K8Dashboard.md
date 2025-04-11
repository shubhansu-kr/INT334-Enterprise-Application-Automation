# **Kubernetes Dashboard Setup Practical**

> Deploy the Kubernetes Dashboard, expose it using NodePort, and access it securely via token-based authentication.

---

## **1. Deploy Kubernetes Dashboard**

Apply the official manifest:

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

---

## **2. Expose Dashboard via NodePort**

Edit the service to change its type from `ClusterIP` to `NodePort`:

```sh
kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard
```

> In the opened editor:

- Locate: `type: ClusterIP`
- Change it to: `type: NodePort`

Save and exit.

---

## **3. Get the NodePort**

```sh
kubectl get svc kubernetes-dashboard -n kubernetes-dashboard
```

From the output, note the **NodePort** value listed in the `PORT(S)` column (for example, `443:30399/TCP` means NodePort is `30399`).

Use this along with the **public IP of the worker node** to access the dashboard:

```url
https://<worker-node-public-ip>:<nodeport>
```

Example:

```url
https://34.125.74.201:30399
```

---

## **4. Create an Admin User**

Create a service account for the dashboard:

```sh
kubectl create serviceaccount admin-user -n kubernetes-dashboard
```

Create a `ClusterRoleBinding` to grant admin permissions:

```sh
kubectl create clusterrolebinding admin-user-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:admin-user
```

---

## **5. Generate Login Token**

Generate an access token for the admin user:

```sh
kubectl -n kubernetes-dashboard create token admin-user
```

Copy this token. You will need it to log in to the Dashboard UI.

---

## **6. Verify Setup**

Ensure everything is running as expected:

```sh
kubectl get nodes
kubectl get pods -n kubernetes-dashboard
```

---

## **Explanation**

This practical sets up a web-based Kubernetes Dashboard interface that helps you monitor and manage your cluster.

### Key Points

- The Dashboard is deployed using an official YAML manifest.
- The service is changed to `NodePort` so it's accessible externally.
- An admin service account is created with full cluster permissions.
- A secure token is generated and used for authentication.
- The dashboard can be accessed via the browser using the worker node's public IP and NodePort.

This method is recommended for non-production environments or educational purposes. In production, it's better to secure access using HTTPS certificates, authentication integrations, or Ingress with proper TLS.
