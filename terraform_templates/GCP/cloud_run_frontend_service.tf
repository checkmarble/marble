resource "google_cloud_run_v2_service" "frontend" {
  name     = "marble-frontend"
  location = local.location
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      min_instance_count = 1
      max_instance_count = 10
    }

    max_instance_request_concurrency = 80
    service_account                  = google_service_account.frontend_service_account.email

    containers {
      image = local.environment.frontend.image

      env {
        name  = "ENV"
        value = local.environment.env_display_name
      }

      env {
        name  = "FIREBASE_API_KEY"
        value = data.google_firebase_web_app_config.frontend.api_key
      }

      env {
        name  = "FIREBASE_APP_ID"
        value = data.google_firebase_web_app_config.frontend.web_app_id
      }

      env {
        name  = "FIREBASE_AUTH_DOMAIN"
        value = data.google_firebase_web_app_config.frontend.auth_domain
      }

      env {
        name  = "FIREBASE_MESSAGING_SENDER_ID"
        value = data.google_firebase_web_app_config.frontend.messaging_sender_id
      }

      env {
        name  = "FIREBASE_PROJECT_ID"
        value = local.project_id
      }

      env {
        name  = "FIREBASE_STORAGE_BUCKET"
        value = data.google_firebase_web_app_config.frontend.storage_bucket
      }

      env {
        name  = "MARBLE_API_DOMAIN"
        value = local.environment.backend.url
      }

      env {
        name  = "MARBLE_APP_DOMAIN"
        value = local.environment.frontend.url
      }

      env {
        name  = "NODE_ENV"
        value = "production"
      }

      env {
        name  = "SENTRY_ENVIRONMENT"
        value = local.environment.env_display_name
      }

      env {
        name  = "SEGMENT_WRITE_KEY"
        value = local.environment.segment_write_key.frontend
      }

      env {
        name  = "SESSION_MAX_AGE"
        value = "43200"
      }

      env {
        name = "SESSION_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.cookie_session_secret.secret_id
            version = "latest"
          }
        }
      }

      env {
        name  = "MARBLE_API_DOMAIN_SERVER"
        value = local.environment.backend.url
      }

      env {
        name  = "MARBLE_API_DOMAIN_CLIENT"
        value = local.environment.backend.url
      }

      ports {
        name           = "http1"
        container_port = 8080
      }

      startup_probe {
        failure_threshold     = 4
        period_seconds        = 5
        initial_delay_seconds = 10
        http_get {
          path = "/healthcheck"
          port = "8080"
        }
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
      template[0].containers[0].image,
    ]
  }
}

# Allow unauthenticated invocations of cloud run service
resource "google_cloud_run_service_iam_binding" "frontend_allow_unauthenticated_invocations" {
  location = google_cloud_run_v2_service.frontend.location
  service  = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
