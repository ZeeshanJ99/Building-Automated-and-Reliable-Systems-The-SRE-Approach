# Let's set up our cloud provider with Terraform
provider "aws" {
    region = "eu-west-1"
}

# Adding a VPC
resource "aws_vpc" "sre_amy_terraform_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "sre_amy_terraform_vpc"
  }
}

# Adding an internet gateway
resource "aws_internet_gateway" "sre_amy_terraform_ig" {
  vpc_id = aws_vpc.sre_amy_terraform_vpc.id
  tags = {
    Name = "sre_amy_terraform_ig"
  }
}

# Adding IG to default route table
resource "aws_route" "sre_amy_route_ig_connection" {
    route_table_id = aws_vpc.sre_amy_terraform_vpc.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sre_amy_terraform_ig.id
}

# Adding a public subnet
resource "aws_subnet" "sre_amy_terraform_public_subnet" {
    vpc_id = aws_vpc.sre_amy_terraform_vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = "true"    # Makes the subnet public
    availability_zone = "eu-west-1a"
    tags = {
      Name = "sre_amy_terraform_public_subnet"
    }
}

# Adding a private subnet
resource "aws_subnet" "sre_amy_terraform_private_subnet" {
    vpc_id = aws_vpc.sre_amy_terraform_vpc.id
    cidr_block = var.private_subnet_cidr
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1b"
    tags = {
      Name = "sre_amy_terraform_private_subnet"
    }
}

# CloudWatch Code Section
# Launch configuration
resource "aws_launch_configuration" "sre_amy_app_terraform_launch_config" {
  name = "sre_amy_app_terraform_launch_config"
  image_id = var.k8_ami_id
  instance_type = "t2.micro"
  key_name = var.aws_key_name
  security_groups = [var.k8_sg]
  associate_public_ip_address = true
}

# Application Load Balancer (ALB)
resource "aws_lb" "sre_amy_terraform_alb" {
  name = "sre-amy-terraform-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.k8_sg]
  subnets = [aws_subnet.sre_amy_terraform_public_subnet.id, aws_subnet.sre_amy_terraform_private_subnet.id]
  tags = {
    Name = "sre-amy-terraform-alb"
  }
}

# Instance target group
resource "aws_lb_target_group" "sre_amy_terraform_target_group" {
  name = "sre-amy-terraform-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sre_amy_terraform_vpc.id
  tags = {
    Name = "sre-amy-terraform-target-group"
  }
}

# Listener
resource "aws_lb_listener" "sre_amy_terraform_listener" {
  load_balancer_arn = aws_lb.sre_amy_terraform_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.sre_amy_terraform_target_group.arn
  }
}

# target group attachment
resource "aws_lb_target_group_attachment" "sre_amy_terraform_tg_attachment" {
  target_group_arn = aws_lb_target_group.sre_amy_terraform_target_group.arn
  target_id = var.k8_instance_id
  port = 80
}
# auto scaling group from launch config
resource "aws_autoscaling_group" "sre_amy_terraform_autoscaling_group" {
    name = "sre_amy_terraform_autoscaling_group"

    min_size = 1
    desired_capacity = 1
    max_size = 3

    vpc_zone_identifier = [
        aws_subnet.sre_amy_terraform_public_subnet.id,
        aws_subnet.sre_amy_terraform_private_subnet.id
    ]

    launch_configuration = aws_launch_configuration.sre_amy_app_terraform_launch_config.name
}

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