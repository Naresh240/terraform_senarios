resource "aws_launch_configuration" "packer_lc" {
  image_id      = "${data.aws_ami.packer_ami.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webservers.id}"]
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "packer_asg" {
  name                 = "terraform-asg-${aws_launch_configuration.packer_lc.name}"
  launch_configuration = "${aws_launch_configuration.packer_lc.name}"
  vpc_zone_identifier = ["${aws_subnet.public.*.id}"]
  min_size             = 2
  max_size             = 3
  load_balancers = ["${aws_elb.terra-elb.id}"]
  health_check_type = "ELB"
  lifecycle {
	create_before_destroy = true
  }
}
