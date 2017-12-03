variable "region" {
description = "AWS region for hosting network"
default = "us-east-1"
}

variable "key_path" {
description = "Key path for SSHing into EC2"
default  = "./ssh/mongo-tf"
}

variable "key_name" {
description = "Key name for SSHing into EC2"
default = "mongo-tf"
}

variable "volume_size_for_db" {
description = "Define volume size for database"
default = "1"
}

variable "amis" {
description = "Base AMI to launch the instances"
default = {
us-east-1 = "ami-aa2ea6d0"
us-east-2 = "ami-aa2ea6d0"
}
}