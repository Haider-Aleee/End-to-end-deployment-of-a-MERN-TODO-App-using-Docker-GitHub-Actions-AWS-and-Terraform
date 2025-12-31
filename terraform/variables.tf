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
  description = "Your IP address for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_public_key_path" {
  description = "Path to the public key file for EC2 key pair"
  type        = string
  default     = "./key.pem"
}

variable "key_pair_name" {
  description = "Name for the EC2 key pair"
  type        = string
  default     = "todo-instance-key-pair"
}

