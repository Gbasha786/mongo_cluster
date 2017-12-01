#resource "aws_instance" "mongo" {
#ami = "${lookup(var.amis, var.region)}"
#availability_zone = "us-east-1a"
#instance_type = "t2.micro"
#key_name = "${var.key_name}"
#vpc_security_group_ids = ["${module.vpc.vpc_id}"] 
##subnet_id = "${module.vpc.private_subnets}"
#source_dest_check = false
#
#tags {
#Name = "Mongo Database Server"
#}
#}

resource "aws_instance" "mongo-1a" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1a.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]

  tags {
    Name = "mongo-1a"
  }
}

resource "aws_eip" "mongo-1a" {
  instance = "${aws_instance.mongo-1a.id}"
  vpc = true
}

resource "aws_instance" "mongo-1b" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1b.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]

  tags {
    Name = "mongo-1b"
  }
}

resource "aws_eip" "mongo-1b" {
  instance = "${aws_instance.mongo-1b.id}"
  vpc = true
}

resource "aws_instance" "mongo-1c" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1c.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]

  tags {
    Name = "mongo-1c"
  }
}

resource "aws_eip" "mongo-1c" {
  instance = "${aws_instance.mongo-1c.id}"
  vpc = true
}



