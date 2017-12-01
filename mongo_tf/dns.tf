data "aws_route53_zone" "selected" {
  name = "chubukin.de."
}

resource "aws_route53_record" "mongo-1a" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "mongo-1a.chubukin.de"
  type = "A"
  ttl = "60"
  records = ["${aws_eip.mongo-1a.public_ip}"]
}

resource "aws_route53_record" "mongo-1b" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "mongo-1b.chubukin.de"
  type = "A"
  ttl = "60"
  records = ["${aws_eip.mongo-1b.public_ip}"]
}

resource "aws_route53_record" "mongo-1c" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "mongo-1c.chubukin.de"
  type = "A"
  ttl = "60"
  records = ["${aws_eip.mongo-1c.public_ip}"]
}