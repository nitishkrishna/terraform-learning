creds_file = "/Users/nitishk/.aws/credentials"

aws_region = "us-west-1"

cred_profile = "terraform"

aws_key_name = "aws-key"

aws_instance_type = "t2.micro"

aws_instance_user = "centos"

aws_key_path = "/Users/nitishk/.ssh/aws-key"

aws_security_group = {
  sg_count               = "2"
  sg_0_name              = "ssh"
  sg_0_ingress_from_port = 22
  sg_0_ingress_to_port   = 22
  sg_0_protocol          = "tcp"
  sg_1_name              = "http"
  sg_1_ingress_from_port = 80
  sg_1_ingress_to_port   = 80
  sg_1_protocol          = "tcp"
}
