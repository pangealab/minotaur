#
# Backend (S3)  Configuration
#

terraform {
  backend "s3" {
    bucket = "minotaur-terraform-backend"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}