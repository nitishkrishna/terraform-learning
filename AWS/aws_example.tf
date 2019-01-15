# Which provider to use
provider "aws" {
  # Provider specific vars
  region = "us-west-1"
  shared_credentials_file = "/Users/nitishk/.aws/credentials"
  # Specific profile of login credentials
  profile = "terraform"
}

# Import an existing keypair into EC2
resource "aws_key_pair" "example" {
  key_name   = "aws-key"
  public_key = "${file("aws-key.pub")}"
}

# Instance details
resource "aws_instance" "example" {
  # Instance AMI Image ID
  ami = "ami-0ad16744583f21877"
  # Instance type (size)
  instance_type = "t2.micro"
  # Use Imported keypair to create
  key_name = "aws-key"

  # Attach Security Group
  vpc_security_group_ids = ["${aws_security_group.instance.id}", "sg-41bb0a3b"]

  # Web Server Code
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  # Add name Tag to instance
  tags {
    Name = "terraform-example-with-key-pair"
  }
}

# Security Group to attach to instance
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  # Inbound HTTP from anywhere
  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Elastic Instance IP
resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

# SSH into Instance: ssh -i <Private Key .pem Path> ubuntu@<External IP>
# To destroy instance:
# comment out aws_instance resource and re-plan and re-apply
# or use terraform destroy
