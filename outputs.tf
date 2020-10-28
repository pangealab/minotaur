#
# Outputs Configuration
#
output "loom-public_ip" {
  value = "${aws_eip.loom_eip.public_ip}"
}