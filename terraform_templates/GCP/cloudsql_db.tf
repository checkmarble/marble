resource "google_sql_database_instance" "marble" {
  name             = local.environment.marble_cloud_sql.name
  region           = local.environment.marble_cloud_sql.location
  database_version = "POSTGRES_15"

  settings {
    tier              = local.environment.marble_cloud_sql.tier
    availability_type = local.environment.marble_cloud_sql.availability_type

    maintenance_window {
      day  = 1
      hour = 0
    }

    deletion_protection_enabled = true

    insights_config {
      query_insights_enabled = true
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      location                       = "eu"
    }

  }

  deletion_protection = true
}

resource "google_sql_database" "marble" {
  name     = "marble"
  instance = google_sql_database_instance.marble.name
}
