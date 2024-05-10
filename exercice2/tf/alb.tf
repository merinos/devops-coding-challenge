module "load_balancer" {
  for_each = {
    default = {
      listeners = [
        {
          name     = "node-tool"
          port     = 80
          protocol = "HTTP"
          target_group = {
            name     = "node-tool"
            port     = 8080
            protocol = "HTTP"
            asg_name = "node-tool"
          }
        }
      ]
    }
  }
  source    = "./modules/alb"
  name      = each.key
  listeners = each.value.listeners
  vpc_id    = "vpc-08763855affd65841"
}
