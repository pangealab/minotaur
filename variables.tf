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

data "aws_availability_zones" "azs" {}

data "aws_region" "current" {}