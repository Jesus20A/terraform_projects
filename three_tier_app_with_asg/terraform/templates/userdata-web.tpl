#!/bin/bash

touch etc/nginx/conf.d/app.conf

cat  <<'EOT' >> /etc/nginx/conf.d/app.conf
server {
    listen       80;
    server_name  ${app_lb_addr};

    location / {
        proxy_pass http://unix:/var/app/app.sock;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_ignore_client_abort on;
    }
}
EOT

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

systemctl start nginx
systemctl start app.service

