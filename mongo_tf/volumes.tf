# create EBS volumes
resource "aws_ebs_volume" "mongo-1a" {
    availability_zone = "us-east-1a"
    size = "${var.volume_size_for_db}"
    tags {
        Name = "mongo-1a"
    }
}

resource "aws_ebs_volume" "mongo-1b" {
    availability_zone = "us-east-1b"
    size = "${var.volume_size_for_db}"
    tags {
        Name = "mongo-1b"
    }
}

resource "aws_ebs_volume" "mongo-1c" {
    availability_zone = "us-east-1c"
    size = "${var.volume_size_for_db}"
    tags {
        Name = "mongo-1c"
    }
}

# attach EBS volume
resource "aws_volume_attachment" "mongo-1a" {
  device_name = "/dev/xvdb"
  instance_id = "${aws_instance.mongo-1a.id}"
  volume_id   = "${aws_ebs_volume.mongo-1a.id}"
}

resource "aws_volume_attachment" "mongo-1b" {
  device_name = "/dev/xvdb"
  instance_id = "${aws_instance.mongo-1b.id}"
  volume_id   = "${aws_ebs_volume.mongo-1b.id}"
}

resource "aws_volume_attachment" "mongo-1c" {
  device_name = "/dev/xvdb"
  instance_id = "${aws_instance.mongo-1c.id}"
  volume_id   = "${aws_ebs_volume.mongo-1c.id}"
}
