[amazonlinux]
%{ for ip in web_servers ~}
${ip}
%{ endfor ~}

[amazonlinux:vars]
ansible_ssh_private_key_file=~/.ssh/abdias-key.pem
ansible_user=ec2-user
