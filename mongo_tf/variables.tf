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

variable "domain_name" {
description = "domain name for mongo servers"
default  = "chubukin.de."
}

variable "volume_size_for_db" {
description = "Define volume size for database"
default = "1"
}
