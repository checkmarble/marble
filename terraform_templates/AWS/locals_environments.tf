locals {

  environments = {

    default = {
      # TO CONFIGURE
      firebase : {
        // Copy the JSON Configuration File from Firebase Console
        apiKey : "AIzaSyAtbEKtaTrIRdmdxs98GPMJBSwTxCkV_gc",
        authDomain : "pixpaymarble.firebaseapp.com",
        projectId : "pixpaymarble",
        storageBucket : "pixpaymarble.appspot.com",
        messagingSenderId : "886300766582",
        appId : "1:886300766582:web:da1111d386d37e85e74a57"
      }
      
      licence_key = ""

      session : {
        secret  = "JeAT8VCKjBs7gVrFY23PG7aSMPqcvNFE", // Change It
        max_age = "43200"
      }

      org : {
        global = "devs@pixpay.fr", // Gloabl Admin Email Address
        name   = "Pixpay", // Organization name
        admin  = "nicolas@pixpay.fr" // Organization Admin Email Address
      }

      segment_write_key = {
        frontend = "bEDdodQ5CBrUFeaHvVClSf0BfuWYyzeN",
        backend  = "JeAT8VCKjBs7gVrFY23PG7aSMPqcvNFE"
      }

      sentry = {
        frontend = {
          dsn = "https://35baab2abd1e46e4d6c28b4963766727@o226978.ingest.us.sentry.io/4507621335367680",
          env = "prod"
        }
        backend  = {
          dsn  =  "https://e2e1767e50571d033eb55a4bdf5f26d9@o226978.ingest.us.sentry.io/4507856676126720",
          env   =  "prod"
        }
      }

      frontend = {
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest"
        domain = "marble.pixpay.app" // Your Application Domain
        url    = "https://marble.pixpay.app" // Your Application URL
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest"
        domain             = "marble-api.pixpay.app" // Your API Domain
        url                = "https://marble-api.pixpay.app" // Your API URL
        max_instance_count = 3
      }

      cron = {
        s3 = "" // S3 for file ingestion ??
      }
    }

  }
}
