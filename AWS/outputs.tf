output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
output "elastic_ip" {
  value = "${aws_eip.ip.public_ip}"
}
