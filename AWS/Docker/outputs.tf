output "security_group" {
  value = "${join(", ", aws_security_group.nginx_docker_sg.*.id)}"
}

output "web_ip" {
  value = "${join(", ", aws_instance.nginx_docker_inst.*.public_ip)}"
}

output "elb_address" {
  value = "${aws_elb.nginx_docker_elb.dns_name}"
}
