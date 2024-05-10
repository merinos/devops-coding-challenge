variable "name" {
  description = "lb name"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "listeners" {
  type = list(object({
    name     = string
    port     = number
    protocol = string
    target_group = object({
      name        = string
      port        = number
      protocol    = optional(string, "TCP")
      target_type = optional(string, "instance")
      asg_name    = string
    })
  }))

}
