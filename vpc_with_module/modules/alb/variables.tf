variable "sg_id" {
  description = "SG id for ALB"
  type = string
}

variable "subnets" {
  description = "Subnets for ALB"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC Id for ALB"
  type = string
}

variable "instances" {
  description = "Instance Id for Target Group Attachment"
  type = list(string)
}