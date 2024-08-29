# --- ECS Task Definition ---

resource "aws_ecs_task_definition" "app" {
  family             = "marble"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "bridge"
  memory             = 256

  container_definitions = jsonencode([{
    name         = "app",
    image        = local.environment.frontend.image,
    essential    = true,
    portMappings = [{ containerPort = 3000, hostPort = 3000 }],



    environment = [
      { name = "PORT", value = "3000" },
      { name = "ENV", value = "production" },
      { name = "NODE_ENV", value = "production" },
      { name = "MARBLE_APP_DOMAIN", value = local.environment.frontend.url },
      { name = "MARBLE_API_DOMAIN", value = local.environment.backend.url },
      { name = "MARBLE_API_DOMAIN_SERVER", value = local.environment.backend.url },
      { name = "MARBLE_API_DOMAIN_CLIENT", value = local.environment.backend.url },
      { name = "FIREBASE_API_KEY", value = local.environment.firebase.apiKey },
      { name = "FIREBASE_AUTH_DOMAIN", value = local.environment.firebase.authDomain },
      { name = "FIREBASE_PROJECT_ID", value = local.environment.firebase.projectId },
      { name = "FIREBASE_STORAGE_BUCKET", value = local.environment.firebase.storageBucket },
      { name = "FIREBASE_MESSAGING_SENDER_ID", value = local.environment.firebase.messagingSenderId },
      { name = "FIREBASE_APP_ID", value = local.environment.firebase.appId },
      { name = "SESSION_SECRET", value = local.environment.session.secret },
      { name = "SESSION_MAX_AGE", value = local.environment.session.max_age },
      { name = "LICENSE_KEY", value = local.environment.licence_key },
      { name = "SENTRY_ENVIRONMENT", value = local.environment.sentry.frontend.env},
      { name = "SENTRY_DSN", value = local.environment.sentry.frontend.dsn },
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
      image        = local.environment.backend.image,
      essential    = true,
      portMappings = [{ containerPort = 8080, hostPort = 8080 }],

      entryPoint : ["./app", "--server", "--migrations"],

      environment = [
        { name = "ENV", value = "production" },
        { name = "NODE_ENV", value = "production" },
        { name = "PG_HOSTNAME", value = "${element(split(":", aws_db_instance.rds-marble.endpoint), 0)}" },
        { name = "PG_PORT", value = "${element(split(":", aws_db_instance.rds-marble.endpoint), 1)}" },
        { name = "PG_USER", value = "postgres" },
        { name = "PG_PASSWORD", value = "${random_string.rds-db-password.result}" },
        { name = "GOOGLE_APPLICATION_CREDENTIALS", value = "/config/credentials.json" },
        { name = "GOOGLE_CLOUD_PROJECT", value = local.environment.firebase.projectId },
        { name = "CREATE_GLOBAL_ADMIN_EMAIL", value = local.environment.org.global },
        { name = "CREATE_ORG_NAME", value = local.environment.org.name },
        { name = "CREATE_ORG_ADMIN_EMAIL", value = local.environment.org.admin },
        { name = "MARBLE_APP_HOST", value = local.environment.frontend.domain },
        { name = "MARBLE_BACKOFFICE_HOST", value = local.environment.backend.domain },
        { name = "SESSION_SECRET", value = local.environment.session.secret },
        { name = "SESSION_MAX_AGE", value = local.environment.session.max_age },
        { name = "LICENSE_KEY", value = local.environment.licence_key },
        { name = "SENTRY_ENVIRONMENT", value = local.environment.sentry.backend.env},
        { name = "SENTRY_DSN", value = local.environment.sentry.backend.dsn },
        { name = "SEGMENT_WRITE_KEY", value = local.environment.segment_write_key.backend },
        { name = "AUTHENTICATION_JWT_SIGNING_KEY", value = "${file("config/private.key")}"}
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-region"        = var.aws_region,
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
          "awslogs-stream-prefix" = "marble-api"
        }
      },

      mountPoints : [
        { "sourceVolume" : "config-volume", "containerPath" : "/config" }
      ]


      depends_on = [aws_db_instance.rds-marble]
  }, 
  {
      name         = "cron",
      image        = local.environment.backend.image,
      essential    = true,
      
      entryPoint : ["./app", "--cron-scheduler"],

      environment = [
        { name = "ENV", value = "production" },
        { name = "NODE_ENV", value = "production" },
        { name = "PG_HOSTNAME", value = "${element(split(":", aws_db_instance.rds-marble.endpoint), 0)}" },
        { name = "PG_PORT", value = "${element(split(":", aws_db_instance.rds-marble.endpoint), 1)}" },
        { name = "PG_USER", value = "postgres" },
        { name = "PG_PASSWORD", value = "${random_string.rds-db-password.result}" },
        { name = "GCS_INGESTION_BUCKET", value = "data-ingestion-bucket" }, // Not Use for AWS ??
        { name = "AWS_REGION", value = var.aws_region},
        { name = "AWS_ACCESS_KEY", value = var.aws_access_key_id },
        { name = "AWS_SECRET_KEY", value = var.aws_secret_access_key },
        { name = "FAKE_AWS_S3", value = local.environment.cron.s3 },
        { name = "LICENSE_KEY", value = local.environment.licence_key },
        { name = "SENTRY_ENVIRONMENT", value = local.environment.sentry.backend.env},
        { name = "SENTRY_DSN", value = local.environment.sentry.backend.dsn },
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-region"        = var.aws_region,
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
          "awslogs-stream-prefix" = "marble-cron"
        }
      },

      depends_on = [aws_db_instance.rds-marble]
  }])

  volume {
    name      = "config-volume"
    host_path = "/tmp"
  }

}


