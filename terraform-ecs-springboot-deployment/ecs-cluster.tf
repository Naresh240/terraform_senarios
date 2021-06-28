### ECS

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "springboot-cluster"
}

resource "aws_ecs_task_definition" "task-definition" {
  family                   = "springboot-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<DEFINITION
[
  {
    "cpu": 1,
    "image": "${var.docker-image}",
    "memory": 2048,
    "name": "springboot-application",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "protocol"	: "tcp",
        "containerPort"	: var.container-port,
        "hostPort"	: var.container-port
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "ecs-service" {
  name            = "springboot-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = data.aws_subnet_ids.default.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.springboot-sg.arn
    container_name   = "springboot-application"
    container_port   = var.container-port
  }

  depends_on = [aws_alb_listener.springboot_deploy]
}
