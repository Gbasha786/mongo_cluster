output "mongo-1a-ip" {
  value = "${aws_eip.mongo-1a.public_ip}"
}

output "mongo-1b-ip" {
  value = "${aws_eip.mongo-1b.public_ip}"
}

output "mongo-1c-ip" {
  value = "${aws_eip.mongo-1c.public_ip}"
}
