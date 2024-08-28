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

      org : {
        global = "devs@pixpay.fr",
        name = "PixpayMarble",
        admin = "nicolas@pixpay.fr"
      }

      frontend = {
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest"
        domain = "marble.pixpay.app"
        url    = "https://marble.pixpay.app"
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest"
        domain             = "marble-api.pixpay.app"
        url                = "https://marble-api.pixpay.app"
        max_instance_count = 3
      }
    }

  }
}
