resource "aws_lb_target_group" "web_server_tg" {
  name     = "web-servers-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.dev-vpc.id
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 4
  }
  
}

resource "aws_lb_target_group_attachment" "web_servers_tg_attachment" {

  count = 2
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = data.aws_instances.web-servers.ids[count.index]
  port             = 80
  depends_on = [ data.aws_instances.web-servers ]
}

resource "aws_lb" "web_server_alb" {
  name               = "web-server-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_servers_sg.id]
  subnets            = [aws_subnet.dev-vpc-web_server-pub-subnet-1.id, aws_subnet.dev-vpc-web_server-pub-subnet-2.id]

  tags = {
    Name = "web_servers_load_balancer"
    Env = "dev"
  }
}

resource "aws_lb_listener" "web_servers_lb_listener" {
  load_balancer_arn = aws_lb.web_server_alb.arn
  port              = "80"
  protocol          = "HTTP"
    
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }  
}