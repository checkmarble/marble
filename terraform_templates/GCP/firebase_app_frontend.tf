resource "google_firebase_web_app" "frontend" {
  display_name = "Marble"

  deletion_policy = "DELETE"
}

data "google_firebase_web_app_config" "frontend" {
  web_app_id = google_firebase_web_app.frontend.app_id
}
