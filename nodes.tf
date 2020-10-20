#
# Nodes Configuration
#

resource "aws_key_pair" "keypair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# resource "aws_instance" "loom" {
#   ami                  = data.aws_ami.centos7.id
#   instance_type        = "t3.medium"
#   subnet_id            = aws_subnet.loom.id
#   vpc_security_group_ids = [
#     aws_security_group.loom.id
#   ]
#   key_name = aws_key_pair.keypair.key_name
#   tags = "${merge(
#     local.common_tags,
#     map(
#       "Name", "Loom"
#     )
#   )}"
# }