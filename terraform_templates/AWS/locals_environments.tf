locals {

  environments = {

    default = {
      # TO CONFIGURE
      firebase : {
        apiKey : "AIzaSyAtbEKtaTrIRdmdxs98GPMJBSwTxCkV_gc",
        authDomain : "pixpaymarble.firebaseapp.com",
        projectId : "pixpaymarble",
        storageBucket : "pixpaymarble.appspot.com",
        messagingSenderId : "886300766582",
        appId : "1:886300766582:web:da1111d386d37e85e74a57"
      }

      session : {
        secret = "da1111d386d37e85e74a57"
      }

      frontend = {
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest"
        domain = "app.mydomain.com"
        url    = "https://marble.pixpay.app"
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest"
        domain             = "api.mydomain.com"
        url                = "https://marble-api.pixpay.app"
        max_instance_count = 3
      }
    }

  }
}
