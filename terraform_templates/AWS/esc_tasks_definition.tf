# --- ECS Task Definition ---

resource "aws_ecs_task_definition" "app" {
  family             = "marble"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "bridge"
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([{
    name         = "app",
    image        = "strm/helloworld-http:latest",
    essential    = true,
    portMappings = [{ containerPort = 80, hostPort = 80 }],

    environment = [
      { name = "EXAMPLE", value = "example" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = var.aws_region,
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "marble-app"
      }
    },
  },
  {
    name         = "api",
    image        = "testcontainers/helloworld:latest",
    essential    = false,
    portMappings = [{ containerPort = 8080, hostPort = 8080 }],

    environment = [
      { name = "EXAMPLE", value = "example" }
    ]

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = var.aws_region,
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "marble-api"
      }
    },
  }])
}