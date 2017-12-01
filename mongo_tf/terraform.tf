terraform {
  backend "s3" {
    bucket = "mongo-tf-remote-state"
    region = "us-east-1"
    key    = "mongo.tfstate"
  }
}