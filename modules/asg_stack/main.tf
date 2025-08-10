resource "aws_launch_template" "lt" {
  name_prefix   = "${var.name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = var.security_group_ids
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name
      Role = var.role
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical owner id
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = var.name
  max_size                  = var.desired_capacity
  min_size                  = var.desired_capacity
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = var.role
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
