variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-2"
}

variable "ami" {
  description = "AMI id"
  default     = "ami-e251209a" # Amazon Linux AMI
}
variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.1.0/24"
}
