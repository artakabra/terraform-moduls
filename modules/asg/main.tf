resource "aws_launch_template" "node_lt" {
  name          = "${var.project_name}-LT"
  image_id      = var.amis["${var.aws_region}"]
  instance_type = var.instance_type
  key_name      = aws_key_pair.vm_key.id
  iam_instance_profile {
    name = "ECR"
  }

  user_data = base64encode(file("../../data.sh"))

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web" {
  name                      = "${var.project_name}-asg"
  wait_for_capacity_timeout = "5m"
  health_check_grace_period = "300"
  health_check_type         = "EC2"
  force_delete              = true
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size

  target_group_arns = [
    aws_lb_target_group.target-group.arn
  ]

  launch_template {
    id      = aws_launch_template.node_lt.id
    version = "$Latest"
  }

  # launch_configuration = aws_launch_configuration.web.name
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 70
    }
    triggers = [/*"launch_template",*/ "desired_capacity"]
  }

  vpc_zone_identifier = [
    "${var.subnet_az_a}",
    "${var.subnet_az_b}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

# Using my local public key
resource "aws_key_pair" "vm_key" {
  key_name   = "id_rsa"
  public_key = file("/home/art/.ssh/id_rsa.pub")
}
