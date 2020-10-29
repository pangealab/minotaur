#
# Nodes Configuration
#

resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_eip" "loom_eip" {
  instance = aws_instance.loom.id
  vpc      = true
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom"
    )
  )
}

data "template_file" "setup-node" {
  template = "${file("${path.module}/files/setup-node.sh")}"
  vars = {
    availability_zone = data.aws_availability_zones.azs.names[0]
    aws_access_key_id = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  }
}

resource "aws_instance" "loom" {
  ami                  = data.aws_ami.centos7.id
  instance_type        = "t3.xlarge"
  subnet_id            = aws_subnet.loom.id
  user_data            = data.template_file.setup-node.rendered
  vpc_security_group_ids = [
    aws_security_group.loom.id
  ]
  root_block_device {
    volume_size = 100
    volume_type = "gp2"
  }
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 500
    volume_type = "gp2"
  }
  key_name = aws_key_pair.keypair.key_name
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom"
    )
  )
}