resource "template_file" "userdata" {
    filename = "userdata.sh"
}


# create EC2 instances
resource "aws_instance" "mongo-1a" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1a.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]
  user_data = "${template_file.userdata.rendered}"
  tags {
    Name = "mongo-1a"
  }
}

resource "aws_instance" "mongo-1b" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1b.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]
  user_data = "${template_file.userdata.rendered}"
  tags {
    Name = "mongo-1b"
  }
}

resource "aws_instance" "mongo-1c" {
  ami = "ami-aa2ea6d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public_subnet_us_east_1c.id}"
  security_groups = ["${aws_security_group.mongo-sec-gr.id}"]
  user_data = "${template_file.userdata.rendered}"
  tags {
    Name = "mongo-1c"
  }
}

#resource "local_file" "aws_ansible_inventory" {
#  content  = "[${var.name_prefix}]\n${join("\n",formatlist("%v ansible_host=%v", #aws_instance.node.*.tags.Name, aws_instance.node.*.public_ip))}\n"
#  filename = "ansible/${var.name_prefix}"
#  count    = "${lookup(map("aws", "${signum(var.nodes)}"), "${var.provider}" , "0")}"
#}


