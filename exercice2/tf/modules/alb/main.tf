data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_lb" "lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.subnets.ids
}

resource "aws_lb_target_group" "target_group" {
  for_each    = { for k, v in var.listeners : v.name => v }
  name        = each.value.target_group.name
  port        = each.value.target_group.port
  protocol    = each.value.target_group.protocol
  target_type = each.value.target_group.target_type
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  for_each          = { for k, v in var.listeners : v.name => v }
  load_balancer_arn = aws_lb.lb.arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  for_each               = { for k, v in var.listeners : v.name => v }
  autoscaling_group_name = each.value.target_group.asg_name
  lb_target_group_arn    = aws_lb_target_group.target_group[each.key].arn
}
