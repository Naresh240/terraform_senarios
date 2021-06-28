data "aws_ami" "packer_ami" {
  most_recent = true
filter {
    name   = "name"
    values = ["packer*"]
  }
filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
owners = ["791382328408"]
}
