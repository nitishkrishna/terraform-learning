# Which provider to use
provider "aws" {
  # Provider specific vars and cred profile
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.creds_file}"
  profile                 = "${var.cred_profile}"
}

# Get Default AWS VPC
data "aws_vpc" "default" {
  default = "true"
}

# Get Default AWS SG ID
data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

# Security Groups to attach to instances for HTTP and SSH
resource "aws_security_group" "nginx_docker_sg" {
  count = "${var.aws_security_group["sg_count"]}"

  name        = "terraform_security_group_${lookup(var.aws_security_group, "sg_${count.index}_name")}"
  description = "AWS security group for ${lookup(var.aws_security_group, "sg_${count.index}_name")} in terraform example"

  ingress {
    from_port   = "${var.aws_security_group["sg_${count.index}_ingress_from_port"]}"
    to_port     = "${var.aws_security_group["sg_${count.index}_ingress_to_port"]}"
    protocol    = "${var.aws_security_group["sg_${count.index}_protocol"]}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Terraform Nginx Cluster AWS security group ${count.index}"
  }
}

# Load Balancer for three Nginx nodes
resource "aws_elb" "nginx_docker_elb" {
  name = "terraform-nginx-docker-elb"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  availability_zones = [
    "${aws_instance.nginx_docker_inst.*.availability_zone}",
  ]

  instances = [
    "${aws_instance.nginx_docker_inst.*.id}",
  ]
}

# Spawn 3 load balanced instances for Dockerized NginX to run on
resource "aws_instance" "nginx_docker_inst" {
  count = 3

  instance_type     = "${var.aws_instance_type}"
  ami               = "${lookup(var.aws_amis, var.aws_region)}"
  availability_zone = "${lookup(var.aws_availability_zones, count.index)}"
  key_name          = "${var.aws_key_name}"

  security_groups = ["${aws_security_group.nginx_docker_sg.*.name}",
    "${data.aws_security_group.default.name}",
  ]

  associate_public_ip_address = true

  provisioner "file" {
    source      = "files/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      user        = "${var.aws_instance_user}"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo docker pull nginx",
      "sudo docker run -d -p 80:80 -v /tmp:/usr/share/nginx/html --name nginx_${count.index} nginx",
      "sudo sed -iE \"s/{{ hostname }}/`hostname`/g\" /tmp/index.html",
      "sudo sed -iE \"s/{{ container_name }}/nginx_${count.index}/g\" /tmp/index.html",
    ]

    connection {
      type        = "ssh"
      user        = "${var.aws_instance_user}"
      private_key = "${file(var.aws_key_path)}"
    }
  }

  tags {
    Name = "Terraform Nginx Instance ${count.index}"
  }
}
