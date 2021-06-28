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

variable "cronType" {
 
}

variable "scaleup_recurrence" {
  description = "recurrence for scheduling autoscaling"
  type = map(string)
  default = {
    "daily" = "20 08 * * *"
    "hourly" = "35 08 * * *"  
  }
}

variable "scaledown_recurrence" {
  description = "recurrence for scheduling autoscaling"
  default = "30 08 * * *"
}
