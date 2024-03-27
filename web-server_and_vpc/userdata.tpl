#!/bin/bash
sudo dnf install -y nginx
sudo systemctl enable --now nginx
echo "<h1>Hello World from instance: $(ec2-metadata -i | awk '{{ print $2 }}') instance type: $(ec2-metadata -t | awk '{{ print $2 }}') </h1>" > /usr/share/nginx/html/index.html