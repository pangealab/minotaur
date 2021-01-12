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

variable "loom_skip_hardware_req" {
  description = "Loom Skip Harware Requirement"
}

variable "loom_home" {
  description = "Loom Home"
}

variable "loom_web_access" {
  description = "Loom Web Access"
}

variable "loom_client_name" {
  description = "Loom Client Name"
}

variable "loom_super_admin_password" {
  description = "Loom Super Admin Password"
}

variable "loom_address" {
  description = "Loom Address"
}

variable "loom_db_remote" {
  description = "Loom DB Remote"
}

variable "loom_es_host" {
  description = "Loom ES Host"
}

variable "loom_network_prefix" {
  description = "Loom Network Prefix"
}

data "aws_availability_zones" "azs" {}

data "aws_region" "current" {}