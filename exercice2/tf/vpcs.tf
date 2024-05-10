module "vpc" {
  source = "./modules/vpc/"
  name   = "default"
  cidr   = "10.1.0.0/16"
  azs = {
    eu-west-1a = {
      private_nat_subnet = "10.1.0.0/24"
      public_subnet      = "10.1.1.0/24"
    }
  }
}
