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
      { name = "SESSION_MAX_AGE", value = "43200" },
      { name = "LICENSE_KEY", value = "" },
      { name = "FIREBASE_AUTH_EMULATOR_HOST", value = "" },
      { name = "SENTRY_ENVIRONMENT", value = "prod" },
      { name = "SENTRY_DSN", value = "https://35baab2abd1e46e4d6c28b4963766727@o226978.ingest.us.sentry.io/4507621335367680" }
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
      image        = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest",
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
        { name = "SESSION_MAX_AGE", value = "43200" },
        { name = "LICENSE_KEY", value = "" },
        { name = "FIREBASE_AUTH_EMULATOR_HOST", value = "" },
        { name = "SENTRY_ENVIRONMENT", value = "prod" },
        { name = "SENTRY_DSN", value = "https://e2e1767e50571d033eb55a4bdf5f26d9@o226978.ingest.us.sentry.io/4507856676126720" },
        { name = "SEGMENT_WRITE_KEY", value = "-hC8qrY2OLhUpl1Xycw523tbuClxlQR6u"},
        { name = "AUTHENTICATION_JWT_SIGNING_KEY", value = "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgHLR51CUQpjMUwU6qmt9ZmDBR348sN7fNtvzmKPEkGp8Fd/uYA+Q\nvs92FWSbiYM5x4XgUJzzmE3BF2lC85usSLqEw1dj+75Ae9bcpqPdz/im8ylV/ihh\nnTUU0ufjY6dugdoP6VoSuSqPG3rnq6Be07qtMBXs44nBaU4XvpF/rkFJAgMBAAEC\ngYA5kYqz+RIHAHMjrQ1jRYV+P4oz/gQEStB7qYA/pD9wVHS3SRJ6220AIcmKHv3s\ngJzMP/LLLsuPOKAfU8VGqTPxOns9XZG7fTaZ+H3GgvVR/BnpN6+JbSLANei5DBJn\nBzqR8zoC1+VPTzMa5iDLV7r1dDPeIgMN2Lex6gi3IODTnQJBAMojx1nzBMkrjZPC\nRulAMdAOuhJ/pFAQtmcNVtO9mZOVzEojwnxc9Y/rOR7xrAcywu4G434a+fVGaX+W\n1NtNcdcCQQCRaex6sm6yk/jL7bZNktTIIyINMZyE0jBwE4+zBwC6/Y74U7plzGzO\nfgxIS9+pSFBnzqghWT05TDP2RZEcI8HfAkEAvXQrM7MBmUqotwQvUg5Ioagr3Yqk\nhiYjzxJBftMFTb3oatR5Q/YccXcVYls/0L9S06TBM0A1Zh1IY70KY0CCoQJBAIjX\nHkQksAl7OHFoBNuhZn3kmgHCgyF2z0BZGCyIVYaiYC2OVWXA50+2zIYoaJTcSVY2\n4n9nhDbsYCXMN488kw8CQFQz7x5heNKXZ/b9fzFeYbme9WHA5swjdsKMWHn3cSV4\nsQ/6QaRTlW/OYIxf6BK0zYmYjS2fKLjxgPbpLrLhDP0=\n-----END RSA PRIVATE KEY-----"}
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
  }])

  volume {
    name      = "config-volume"
    host_path = "/tmp"
  }

}


