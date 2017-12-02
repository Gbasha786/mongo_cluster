# create VPC
resource "aws_vpc" "mongo-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "mongo-vpc"
  }
}

# create subnets each for instance
resource "aws_subnet" "public_subnet_us_east_1a" {
  vpc_id                  = "${aws_vpc.mongo-vpc.id}"
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name =  "Subnet 1a"
  }
}

resource "aws_subnet" "public_subnet_us_east_1b" {
  vpc_id                  = "${aws_vpc.mongo-vpc.id}"
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name =  "Subnet 1b"
  }
}

resource "aws_subnet" "public_subnet_us_east_1c" {
  vpc_id                  = "${aws_vpc.mongo-vpc.id}"
  cidr_block              = "10.0.103.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1c"
  tags = {
    Name =  "Subnet 1c"
  }
}

# GW for VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.mongo-vpc.id}"
  tags {
        Name = "InternetGateway"
    }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.mongo-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

# Associate subnet public_subnet_us_east_1a to public route table
resource "aws_route_table_association" "public_subnet_us_east_1a_association" {
    subnet_id = "${aws_subnet.public_subnet_us_east_1a.id}"
    route_table_id = "${aws_vpc.mongo-vpc.main_route_table_id}"
}

# Associate subnet public_subnet_us_east_1b to public route table
resource "aws_route_table_association" "public_subnet_us_east_1b_association" {
    subnet_id = "${aws_subnet.public_subnet_us_east_1b.id}"
    route_table_id = "${aws_vpc.mongo-vpc.main_route_table_id}"
}

# Associate subnet public_subnet_us_east_1c to public route table
resource "aws_route_table_association" "public_subnet_us_east_1c_association" {
    subnet_id = "${aws_subnet.public_subnet_us_east_1c.id}"
    route_table_id = "${aws_vpc.mongo-vpc.main_route_table_id}"
}

# create security group one for all instances
resource "aws_security_group" "mongo-sec-gr" {
  name = "mongo-sec-gr"
  description = "Allow SSH traffic from the internet to mongo-sec-gr"
  vpc_id = "${aws_vpc.mongo-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create Elastic IPs for each instance
resource "aws_eip" "mongo-1b" {
  instance = "${aws_instance.mongo-1b.id}"
  vpc = true
}

resource "aws_eip" "mongo-1a" {
  instance = "${aws_instance.mongo-1a.id}"
  vpc = true
}

resource "aws_eip" "mongo-1c" {
  instance = "${aws_instance.mongo-1c.id}"
  vpc = true
}
