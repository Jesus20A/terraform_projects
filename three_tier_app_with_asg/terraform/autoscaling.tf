resource "aws_launch_template" "app-template" {
  name_prefix     = "test"
  image_id        = data.aws_ami.app.id
  instance_type   = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.web_servers_sg.id ]
  key_name = "abdias-key"
  iam_instance_profile {
    name = aws_iam_instance_profile.app-server-instance-profile.name
  }
  user_data = "${base64encode(data.template_file.app-template-file.rendered)}"

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "web-server"
        Env = "dev"
    }
  }

  tags = {
    Name = "App_autoscaling_group"
    Env = "dev"
  }
  depends_on = [ data.template_file.app-template-file ]
}

resource "aws_autoscaling_group" "app-autoscale" {
  name                  = "test-autoscaling-group"
  max_size              = 4
  min_size              = 2
  health_check_type     = "ELB"
  target_group_arns     = [aws_lb_target_group.web_server_tg.arn ]
  vpc_zone_identifier   = [aws_subnet.dev-vpc-web_server-pub-subnet-1.id, aws_subnet.dev-vpc-web_server-pub-subnet-2.id]

  launch_template {
    id      = aws_launch_template.app-template.id
    version = aws_launch_template.app-template.latest_version
  }

  depends_on = [ aws_lb.web_server_alb ]
}

resource "aws_autoscaling_policy" "app-asg-up" {
  name                   = "app-asg-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-autoscale.name
}

resource "aws_autoscaling_policy" "app-asg-down" {
  name                   = "app-asg-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-autoscale.name
}