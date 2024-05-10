resource "aws_launch_template" "default" {
  name_prefix   = "default"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = var.name
  vpc_zone_identifier = var.vpc_subnet_ids
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }
}
