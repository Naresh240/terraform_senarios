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

variable "scaleup_start_time" {
  description = "start time for scheduling autoscaling"
  default = "2020-07-22T02:50:00Z"
}

variable "scaleup_recurrence" {
  description = "recurrence for scheduling autoscaling"
  default = "50 02 * * *"
}

variable "scaledown_start_time" {
  description = "start time for scheduling autoscaling"
  default = "2020-07-22T02:55:00Z"
}

variable "scaledown_recurrence" {
  description = "recurrence for scheduling autoscaling"
  default = "55 02 * * *"
}
