module "asgs" {
  source = "./modules/asg/"
  for_each = {
    node-tool = {
      desired_capacity = 1
      instance_type    = "t3a.micro"
      max_size         = 1
      min_size         = 1
      instance_profile = "default"
      ami_id           = "ami-0d7e942c185ae1128" # XXX: should use data.aws_ami
    }
  }

  vpc_subnet_ids = ["subnet-00f2fa67f8a8ccc17", "subnet-061538c04d739ff82", "subnet-0688f1bcfeaee7349"]

  name             = each.key
  instance_type    = each.value.instance_type
  desired_capacity = each.value.desired_capacity
  min_size         = each.value.min_size
  max_size         = each.value.max_size
  ami_id           = each.value.ami_id
}
