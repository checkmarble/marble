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
    image        = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest",
    essential    = true,
    portMappings = [{ containerPort = 3000, hostPort = 3000 }],

    

    environment = [
      { name = "PORT", value = "3000" },
      { name = "ENV", value = "production" },
      { name = "NODE_ENV", value = "production" },
      { name = "SESSION_MAX_AGE", value = "43200" },
      { name = "MARBLE_APP_DOMAIN", value = local.environment.frontend.url },
      { name = "MARBLE_API_DOMAIN", value = local.environment.backend.url},
      { name = "MARBLE_API_DOMAIN_SERVER", value = local.environment.backend.url },
      { name = "MARBLE_API_DOMAIN_CLIENT", value = local.environment.backend.url },
      { name = "FIREBASE_API_KEY", value = local.environment.firebase.apiKey },
      { name = "FIREBASE_AUTH_DOMAIN", value = local.environment.firebase.authDomain },
      { name = "FIREBASE_PROJECT_ID", value = local.environment.firebase.projectId },
      { name = "FIREBASE_STORAGE_BUCKET", value = local.environment.firebase.storageBucket },
      { name = "FIREBASE_MESSAGING_SENDER_ID", value = local.environment.firebase.messagingSenderId },
      { name = "FIREBASE_APP_ID", value = local.environment.firebase.appId },
      { name = "SESSION_SECRET", value = local.environment.session.secret },
      { name = "LICENSE_KEY", value = "" }
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
