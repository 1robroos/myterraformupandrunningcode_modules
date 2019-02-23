#output "elb_dns_name" {
#  value = "${aws_elb.example.dns_name}"
#}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

output "instance_security_group_id" {
  value = "${aws_security_group.instance.id}"
}
