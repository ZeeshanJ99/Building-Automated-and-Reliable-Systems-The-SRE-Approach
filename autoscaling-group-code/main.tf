# autoscaling policy
# TODO: make one for RequestCountPerTarget
resource "aws_autoscaling_policy" "sre_amy_terraform_as_policy" {
    name = "sre_amy_terraform_as_policy"
    policy_type = "TargetTrackingScaling"
    estimated_instance_warmup = 100

    autoscaling_group_name = aws_autoscaling_group.sre_amy_terraform_autoscaling_group.name

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 2.0
    }
}

resource "aws_autoscaling_policy" "sre_amy_CPU_scale_down_policy" {
    name = "sre_amy_CPU_scale_down_policy"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.sre_amy_terraform_autoscaling_group.name
}

resource "aws_cloudwatch_metric_alarm" "sre_amy_CPU_scale_down_alarm" {
    alarm_name = "sre_amy_CPU_scale_down_policy"
    comparison_operator = "LessThanThreshold"

    metric_name = "CPUUtilization"
    statistic = "Average"

    threshold = 2
    period = 120
    evaluation_periods = 2

    namespace = "AWS/EC2"
    alarm_description = "Monitors ASG EC2 average cpu utilization (for scale down policy)"
    alarm_actions = [aws_autoscaling_policy.sre_amy_CPU_scale_down_policy.arn]
}