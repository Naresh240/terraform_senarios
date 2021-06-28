variable "docker-image" {
  type = string
  default = "653308993752.dkr.ecr.us-west-1.amazonaws.com/springboot-ecr:latest"
}

variable "container-port" {
  default = 8080
}
