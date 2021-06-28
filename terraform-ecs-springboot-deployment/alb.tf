resource "aws_alb" "ecs-alb" {
  name            = "springboot-alb"
  subnets         = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.ecs_tasks.id]
}

resource "aws_alb_target_group" "springboot-sg" {
  name        = "springboot-tg"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the blue target group
resource "aws_alb_listener" "springboot_deploy" {
  load_balancer_arn = aws_alb.ecs-alb.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.springboot-sg.id
    type             = "forward"
  }
}
