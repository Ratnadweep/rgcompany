variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_01_cidr" {
  description = "Public subnet 1 CIDR"
  type        = string
}

variable "public_subnet_02_cidr" {
  description = "Public subnet 2 CIDR"
  type        = string
}

variable "az1" {
  description = "Availability zone 1"
  type        = string
}

variable "az2" {
  description = "Availability zone 2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}