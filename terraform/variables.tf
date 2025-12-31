variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr_block" {
  description = "The IPv4 CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrsubnet(var.vpc_cidr_block, 0, 0))
    error_message = "Must be a valid IPv4 CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "my_ip" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

