#
# Providers Configuration
#

provider "aws" {
  region  = "us-east-2"
  version = ">= 2.38.0"
}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
