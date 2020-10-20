#
# Variables Configuration
#

variable "cluster-name" {
  default = "minotaur"
  type    = string
}

data "aws_availability_zones" "azs" {}