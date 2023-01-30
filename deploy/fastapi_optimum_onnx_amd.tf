resource "aws_lb" "fastapi_optimum_onnx_amd" {
  name            = "fastapi-optimum-onnx-amd-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "fastapi_optimum_onnx_amd" {
  load_balancer_arn = aws_lb.fastapi_optimum_onnx_amd.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.fastapi_optimum_onnx_amd.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "fastapi_optimum_onnx_amd" {
  name        = "fastapi-optimum-onnx-amd-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"
}

resource "aws_ecs_task_definition" "fastapi_optimum_onnx_amd" {
  family                   = "fastapi-optimum-onnx-amd-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 4096
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = <<DEFINITION
[
  {
    "image": "airklizz/fastapi-optimum-onnx:latest",
    "cpu": 1024,
    "memory": 4096,
    "name": "fastapi-optimum-onnx-amd-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.ecs_log_group.name}",
        "awslogs-region": "eu-west-3",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
DEFINITION
}

resource "aws_security_group" "fastapi_optimum_onnx_amd_task" {
  name        = "fastapi-optimum-onnx-amd-task-security-group"
  vpc_id      = aws_vpc.default.id

  # Ingress rule allowing traffic on port 80 from the lb security group
  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "fastapi_optimum_onnx_amd" {
  name            = "fastapi-optimum-onnx-amd-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.fastapi_optimum_onnx_amd.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.fastapi_optimum_onnx_amd_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fastapi_optimum_onnx_amd.id
    container_name   = "fastapi-optimum-onnx-amd-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.fastapi_optimum_onnx_amd]
}