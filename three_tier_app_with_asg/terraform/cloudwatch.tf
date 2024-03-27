resource "aws_cloudwatch_metric_alarm" "alarm-up" {
  alarm_name          = "app-cpu-usage-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app-autoscale.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [ aws_autoscaling_policy.app-asg-up.arn ]
}

resource "aws_cloudwatch_metric_alarm" "alarm-down" {
  alarm_name          = "app-cpu-usage-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app-autoscale.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [ aws_autoscaling_policy.app-asg-down.arn  ] 
}