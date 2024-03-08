resource "google_secret_manager_secret" "postgres_password" {
  secret_id = "POSTGRES_PASSWORD"
  replication {
    user_managed {
      replicas {
        location = local.location
      }
    }
  }
}

resource "google_secret_manager_secret" "authentication_jwt_signing_key" {

  secret_id = "AUTHENTICATION_JWT_SIGNING_KEY"

  replication {
    user_managed {
      replicas {
        location = local.location
      }
    }
  }
}

resource "google_secret_manager_secret" "metabase_jwt_signing_key" {
  secret_id = "COOKIE_SESSION_SECRET"
  replication {
    user_managed {
      replicas {
        location = local.location
      }
    }
  }
}
