#!/usr/bin/env bash

# This script template is expected to be populated during the setup of a
# OpenShift  node. It runs on host startup.

# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1

mkdir -p /etc/aws/
cat > /etc/aws/aws.conf <<- EOF
[Global]
Zone = ${availability_zone}
EOF

# Create initial logs config.
cat > ./awslogs.conf <<- EOF
[general]
state_file = /var/awslogs/state/agent-state

[/var/log/messages]
log_stream_name = loom-node-{instance_id}
log_group_name = /var/log/messages
file = /var/log/messages
datetime_format = %b %d %H:%M:%S
buffer_duration = 5000
initial_position = start_of_file

[/var/log/user-data.log]
log_stream_name = loom-node-{instance_id}
log_group_name = /var/log/user-data.log
file = /var/log/user-data.log
EOF

# Download and run the AWS logs agent.
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
python ./awslogs-agent-setup.py --non-interactive --region us-east-1 -c ./awslogs.conf

# Start the awslogs service, also start on reboot.
# Note: Errors go to /var/log/awslogs.log
service awslogs start
chkconfig awslogs on

# Install packages required to setup Loom.
yum check-update
yum install -y epel-release
yum install -y unzip zip curl wget htop

# Docker setup. Check the version with `docker version`, should be 1.18
curl -fsSL https://get.docker.com/ | sh

# Add centos to docker sudoers
usermod -aG docker centos

# Configure the Docker storage back end to prepare and use our EBS block device.
# http://docs.aws.amazon.com/AWSEC2/  latest/UserGuide/ebs-using-volumes.html
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/xvdf
VG=docker-vg
EOF
docker-storage-setup

# Restart docker and go to clean state as required by docker-storage-setup.
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker

# Allow the ec2-user to sudo without a tty, which is required when we run post
# install scripts on the server.
echo Defaults:ec2-user \!requiretty >> /etc/sudoers

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install AWS CLI 2.0
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create Loom Group
groupadd loom

# Create Loom user
useradd -gusers -s/bin/bash -p $(openssl passwd -1 "changeit") -m loom -G wheel,docker,loom

# Run as Loom
su - loom

# Set AWS Credentials
export AWS_ACCESS_KEY_ID=${aws_access_key_id}
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}

# Copy Loom files from S3 to EC2
aws s3 cp s3://advlab-tank/loom-onprem-stable-3.8.0-b112.tar $HOME/sofie.tar

# Wait
read -p "Pausing for 1 Minutes...." -t 60 ;echo -e  "\nContinuing..."
echo "Continuing ..."

# Unpack Loom
mkdir -p $HOME/sofie
tar -xvf $HOME/sofie.tar -C $HOME/sofie --strip-components=1

# Install Loom
cd $HOME/sofie
export LOOM_SKIP_HARDWARE_REQ=${loom_skip_hardware_req}
export LOOM_HOME=${loom_home}
export LOOM_WEB_ACCESS=${loom_web_access}
export LOOM_CLIENT_NAME=${loom_client_name}
export LOOM_SUPER_ADMIN_PASSWORD=${loom_super_admin_password}
export LOOM_ADDRESS=${loom_address}
export LOOM_DB_REMOTE=${loom_db_remote}
export LOOM_ES_HOST=${loom_es_host}
export LOOM_NETWORK_PREFIX=${loom_network_prefix}
./deploy.sh