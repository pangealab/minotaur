#
# Variables Configuration
#

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: loom"
  default = "loom"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
  default = "~/.ssh/loom.pub"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
}

data "aws_availability_zones" "azs" {}

data "aws_region" "current" {}