#!/bin/bash

sudo dnf install -y mariadb105-devel gcc python3-devel python3-pip yum-utils stress

cat  <<'EOT' >> /home/ec2-user/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/amzn/2023/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/amzn/2023/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOT

sudo cp /home/ec2-user/nginx.repo /etc/yum.repos.d/nginx.repo

sudo chown root:root /etc/yum.repos.d/nginx.repo

sudo dnf install -y nginx --repo nginx-stable


sudo mkdir /var/app

tar -xzf /home/ec2-user/app.tar.gz
sudo mv /home/ec2-user/app/* /var/app
sudo chown -R ec2-user:nginx /var/app
rm /home/ec2-user/app.tar.gz
cd /var/app 

python3 -m venv venv
source ./venv/bin/activate
pip3 install -r requirements.txt
deactivate
sudo chown -R ec2-user:nginx /var/app


sudo chown root:root /home/ec2-user/app.service
sudo mv /home/ec2-user/app.service /etc/systemd/system/
sudo systemctl daemon-reload







