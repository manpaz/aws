#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y \
    curl \
    wget \
    git \
    htop \
    vim \
    unzip \
    jq \
    awscli \
    openvpn \
    wireguard

# Configure hostname
hostnamectl set-hostname bastion-${environment}

# Create user for deployment
useradd -m -s /bin/bash deployer
usermod -aG sudo deployer

# Configure SSH
mkdir -p /home/deployer/.ssh
chmod 700 /home/deployer/.ssh

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker deployer

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_1.6.0_linux_amd64.zip

# Configure AWS CLI
mkdir -p /home/deployer/.aws
cat > /home/deployer/.aws/config << EOF
[default]
region = us-east-1
output = json
EOF

# Set proper permissions
chown -R deployer:deployer /home/deployer/.aws
chmod 600 /home/deployer/.aws/config

# Create deployment directory
mkdir -p /opt/deployments
chown deployer:deployer /opt/deployments

# Configure log rotation
cat > /etc/logrotate.d/bastion << EOF
/var/log/bastion/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 root root
}
EOF

# Create log directory
mkdir -p /var/log/bastion
chown deployer:deployer /var/log/bastion

# Configure systemd service for bastion
cat > /etc/systemd/system/bastion.service << EOF
[Unit]
Description=Bastion Host Service
After=network.target

[Service]
Type=simple
User=deployer
WorkingDirectory=/opt/deployments
ExecStart=/bin/bash -c 'while true; do sleep 30; done'
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable bastion.service
systemctl start bastion.service

# Log completion
echo "$(date): Bastion host setup completed" >> /var/log/bastion/setup.log
