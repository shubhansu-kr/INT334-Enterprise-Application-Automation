# **Splunk Dashboard Setup on EC2**

---

## **Step 1: Launch an EC2 Instance**

**Instance Configuration:**

- **AMI**: Ubuntu 22.04 LTS (64-bit)
- **Instance Type**: `t3.medium` (2 vCPUs, 4 GB RAM)
- **Storage**: 20 GB `gp3` SSD

---

## **Step 2: Create a Security Group**

Allow both **Inbound** and **Outbound** traffic on the following ports:

| Port | Protocol | Description           |
|------|----------|-----------------------|
| 22   | TCP      | SSH                   |
| 8000 | TCP      | Splunk Web Interface  |
| 9997 | TCP      | Splunk Forwarder Logs |

---

## **Step 3: Connect via SSH**

SSH into your EC2 instance:

```bash
ssh -i <your-key.pem> ubuntu@<EC2-Public-IP>
```

---

## **Step 4: Install Splunk**

Update and upgrade the system:

```bash
sudo apt update && sudo apt upgrade -y
```

Download Splunk Enterprise `.deb` installer:

```bash
wget -O splunk-9.4.1.deb "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"
```

Check file size:

```bash
ls -lh splunk-9.4.1.deb
```

Install the Splunk package:

```bash
sudo dpkg -i splunk-9.4.1.deb
```

---

## **Step 5: Set Admin Credentials (First Time Setup)**

Create the credentials seed file:

```bash
sudo mkdir -p /opt/splunk/etc/system/local
echo -e "[user_info]\nUSERNAME = admin\nPASSWORD = YourStrongPassword" | sudo tee /opt/splunk/etc/system/local/user-seed.conf
```

Update file permissions:

```bash
sudo chown -R splunk:splunk /opt/splunk/etc/system/local/user-seed.conf
sudo chmod 600 /opt/splunk/etc/system/local/user-seed.conf
```

---

## **Step 6: Start Splunk**

Accept the license and restart:

```bash
sudo /opt/splunk/bin/splunk restart --accept-license
```

---

## **Step 7: Access Splunk Dashboard**

Open your browser and navigate to:

```url
http://<EC2-Public-IP>:8000
```

Login with:

- **Username**: `admin`
- **Password**: `YourStrongPassword`

---

## **Explanation**

This setup deploys the **Splunk Web Dashboard** on an Ubuntu EC2 instance. Here's what happens:

- **Splunk Enterprise** is downloaded and installed manually using the `.deb` package.
- The **user-seed.conf** file is used to pre-set login credentials during the first run.
- Ports 8000 (web UI) and 9997 (for log forwarding) are opened via the security group for Splunk usage.
- After starting Splunk, the web interface becomes available at `http://<EC2-IP>:8000`.

### **Use Case**

- Ideal for monitoring Kubernetes clusters, logs from forwarders, or DevOps pipelines.
- Easily expandable by installing **Splunk Forwarder** on other systems and pointing to this server on port `9997`.
