variable "name" {
  description = "asg name"
  type        = string
}

variable "ami_id" {
  description = "id of the ami to use in the vm if null last cisco debian 11 arm ami will be use"
  type        = string
  default     = null
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  description = "instance type of the vm"
  type        = string
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "root_ebs_type" {
  description = "root ebs type"
  type        = string
  default     = "gp3"
}
