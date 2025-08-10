variable "name" {
  description = "Name of the ASG and Launch Template"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs to assign"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "key_name" {
  description = "SSH keypair name"
  type        = string
}

variable "role" {
  description = "Role tag to assign to instances"
  type        = string
}
