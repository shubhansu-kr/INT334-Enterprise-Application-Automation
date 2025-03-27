# Splunk Dashboard

Create a new master ec2 instance

```text

EC2 Instance Requirements:

​AMI: Ubuntu 22.04 (Lightweight OS)
Instance Type: t3.medium (2 vCPU, 4GB RAM)
Storage: 20GB gp3 SSD
```

Create a new security group:

```text
Security Group (Inbound + Outbound) both:

22 (SSH)
8000 (Splunk Web UI)
9997 (Forwarder Log Port)
```

Run the following commands to launch the splunk dashboard

sudo apt update && sudo apt upgrade -y

wget -O splunk-9.4.1.deb "https://download.splunk.com/products/splunk/releases/9.4.1/linux/splunk-9.4.1-e3bdab203ac8-linux-amd64.deb"

ls -lh splunk-9.4.1.deb

sudo dpkg -i splunk-9.4.1.deb

sudo mkdir -p /opt/splunk/etc/system/local

echo -e "[user_info]\nUSERNAME = admin\nPASSWORD = YourStrongPassword" | sudo tee /opt/splunk/etc/system/local/user-seed.conf

```code
#Note:
    USERNAME = admin
    PASSWORD = YourStrongPassword
```

sudo chown -R splunk:splunk /opt/splunk/etc/system/local/user-seed.conf

sudo chmod 600 /opt/splunk/etc/system/local/user-seed.conf

sudo /opt/splunk/bin/splunk restart --accept-license

open http://EC2-Public-IP:8000
