variable "creds_file" {
  description = "The file with AWS access credentials"
  default     = ""
}

variable "cred_profile" {
  description = "The credentials profile to use"
  default     = "default"
}

variable "region" {
  description = "The AWS region to use"
  default     = "us-west-1"
}

variable "aws_region" {}

variable "aws_key_name" {}

variable "aws_instance_type" {}

variable "aws_instance_user" {}

variable "aws_key_path" {}

variable "aws_amis" {
  default = {
    us-west-1 = "ami-4826c22b" # N California
  }
}

variable "aws_availability_zones" {
  default = {
    "0" = "us-west-1c"
    "1" = "us-west-1b"
    "2" = "us-west-1b"
  }
}

variable "aws_security_group" {
  default = {
    sg_count = 0

    sg_0_name              = ""
    sg_0_ingress_from_port = 0
    sg_0_ingress_to_port   = 0
    sg_0_protocol          = ""

    sg_1_name              = ""
    sg_1_ingress_from_port = 0
    sg_1_ingress_to_port   = 0
    sg_1_protocol          = ""

    sg_2_name              = ""
    sg_2_ingress_from_port = 0
    sg_2_ingress_to_port   = 0
    sg_2_protocol          = ""
  }
}
