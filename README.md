# 1- under terraform.tfvars file, you need to modify access and secret key 
aws_access_key = "AKIAIVNHIBJXEMOGZNNA"
aws_secret_key = "JN1bLQDdND0m8Vr1oUc9CqCCLX5SnS8U03sue/mq"


# 2- create key pair called codedeploy on aws console

# 3- under variables.tf u need to modiy your region and image id 
variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-2"
}

variable "ami" {
  description = "AMI id"
  default     = "ami-e251209a" # Amazon Linux AMI
}

# iniside the project run ansible for deployment
 ansible-playbook ansible-vpc.yml

