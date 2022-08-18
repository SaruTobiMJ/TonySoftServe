variable "aws_region" {
  description = "The AWS region to create the VPC in."
  default     = "us-east-1"
}


variable "vpc-cidr" {
  type    = string
  default = "172.168.0.0/16"
}

variable "pubsubcidr-a" {
  type    = string
  default = "172.168.0.0/20"
}
variable "pubsubcidr-b" {
  type    = string
  default = "172.168.16.0/20"
}
