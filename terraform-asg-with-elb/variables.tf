variable "ami" {
  description = "AMI Instance ID"
  default = "ami-08f3d892de259504d"
}

variable "instance_type" {
  description = "Type of instance"
  default = "t2.micro"
}

variable "key_name" {
  description = "key name for the instance"
  default = "helloworld"
}


