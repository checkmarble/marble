locals {

  environments = {

    production = {
      # TO CONFIGURE
      firebase : {
        // Copy the JSON Configuration File from Firebase Console
        apiKey : "...",
        authDomain : "...",
        projectId : "...",
        storageBucket : "...",
        messagingSenderId : "...",
        appId : "..."
      }
      
      licence_key = ""

      session : {
        secret  = "...", // Change It
        max_age = "43200"
      }

      org : {
        global = "...@...", // Gloabl Admin Email Address
        name   = "...", // Organization name
        admin  = "...@..." // Organization Admin Email Address
      }

      segment_write_key = {
        frontend = "bEDdodQ5CBrUFeaHvVClSf0BfuWYyzeN",
        backend  = "JeAT8VCKjBs7gVrFY23PG7aSMPqcvNFE"
      }

      sentry = {
        frontend = {
          dsn = "...",
          env = "prod"
        }
        backend  = {
          dsn  =  "...",
          env   =  "prod"
        }
      }

      frontend = {
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest"
        domain = "..." // Your Application Domain (ex. app.xxx.xxx)
        url    = "..." // Your Application URL (ex. https://marble-app.xxx.xxx)
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest"
        domain             = "..." // Your API Domain (ex. api.xxx.xxx)
        url                = "..." // Your API URL (ex. https://marble-api.xxx.xxx)
        max_instance_count = 3
      }

      cron = {
        s3 = "" // S3 for file ingestion ??
      }
    }

  }
}
