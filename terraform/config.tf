terraform {
  backend "s3" {
    bucket = "clo835-assignment1-ranju"
    key    = "docker/terraform.tfstate"
    region = "us-east-1"
  }
}