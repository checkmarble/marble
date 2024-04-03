resource "google_cloud_run_v2_service" "backend" {
  name     = "marble-backend"
  location = local.location
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      min_instance_count = 1
      # should be such that max_instances*max_connections_per_pool < max connections per cloud sql instance 
      # (varies between staging and prod)
      max_instance_count = local.environment.backend.max_instance_count
    }

    # should be proportionate to max_connections per pool in the backend sevice
    max_instance_request_concurrency = 50
    service_account                  = google_service_account.backend_service_account.email

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.marble.connection_name]
      }
    }

    containers {
      image = local.environment.backend.image

      env {
        name  = "PG_HOSTNAME"
        value = "/cloudsql/${local.project_id}:${google_sql_database_instance.marble.region}:${google_sql_database_instance.marble.name}"
      }

      env {
        name  = "PG_PORT"
        value = "5432"
      }

      env {
        name  = "PG_USER"
        value = "postgres"
      }

      env {
        name = "PG_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.postgres_password.secret_id
            version = "latest"
          }
        }
      }

      env {
        name  = "ENV"
        value = local.environment.env_display_name
      }

      env {
        name  = "AWS_REGION"
        value = "eu-west-3"
      }

      env {
        name  = "GCS_INGESTION_BUCKET"
        value = google_storage_bucket.data_ingestion.name
      }

      env {
        name  = "GCS_CASE_MANAGER_BUCKET"
        value = google_storage_bucket.case_manager.name
      }

      env {
        name = "AUTHENTICATION_JWT_SIGNING_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.authentication_jwt_signing_key.secret_id
            version = "latest"
          }
        }
      }

      env {
        name  = "SEGMENT_WRITE_KEY"
        value = local.environment.segment_write_key.backend
      }

      env {
        name  = "PG_CONNECT_WITH_SOCKET"
        value = "true"
      }

      env {
        name  = "REQUEST_LOGGING_LEVEL"
        value = "liveness"
      }

      env {
        name  = "LOGGING_FORMAT"
        value = "json"
      }

      env {
        name  = "ENABLE_GCP_TRACING"
        value = "true"
      }

      env {
        name  = "MARBLE_APP_HOST"
        value = local.environment.frontend.domain
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      args = ["--server"]

      ports {
        name           = "h2c"
        container_port = 80
      }

      startup_probe {
        tcp_socket {
          port = 80
        }
      }

      liveness_probe {
        http_get {
          path = "/liveness"
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
      template[0].containers[0].image,
    ]
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_secret_manager_secret_iam_member.secret_access_postgres_password,
    google_secret_manager_secret_iam_member.secret_access_authentication_jwt_signing_key,
  ]

}

# Allow unauthenticated invocations of cloud run service
resource "google_cloud_run_service_iam_binding" "backend_allow_unauthenticated_invocations" {
  location = google_cloud_run_v2_service.backend.location
  service  = google_cloud_run_v2_service.backend.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_project_iam_member" "cloud_run_tracing_agent" {
  project = local.project_id
  role    = "roles/cloudtrace.agent"
  member  = google_service_account.backend_service_account.member
}
