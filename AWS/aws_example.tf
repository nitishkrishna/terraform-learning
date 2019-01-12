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
  # Add name Tag to instance
  tags {
    Name = "terraform-example-with-key-pair"
  }
}

# SSH into Instance: ssh -i <Private Key .pem Path> ubuntu@<External IP>
# To destroy instance, comment out aws_instance resource and re-plan and re-apply
