output "web_alb_dns_anme" {
    value = aws_lb.web_server_alb.dns_name
}

output "conf-serv-ip" {
  value = aws_instance.conf-server.public_ip
}

output "web_serv_public_ips" {
    value = data.aws_instances.web-servers.private_ips
}