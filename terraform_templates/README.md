# Using the terraform template examples

## Disclaimer

The terraform templates shared in this folder are community contributions and are purely indicative of what a marble deployment on a cloud environment could look like.
They come wihout guarantee and support.

Be advised that a successful deployment may require several rounds of iterative tweaking of ressources/values, as some steps require manual actions to succeed. For instance, using the GCP terraform files, the backend service on Cloud Run will only deploy successfully after the relevant secrets versions have been created in GCP Secret Manager (secret versions are not created in terraform so that their values are not stored in the terraform state in plain text).

The GCP terraform files are largely inspired from Marble's internal cloud deployment, but are simplified to match a "bare bones" deployment needs.

## Usage

### GCP

- Create a new project
- Create a GCS bucket (in this project, or another) to store the terraform state
- create an admin service account in the project & download a service account key
- Place the downloaded key in the (gitignored) service-account-key folder
- Run `terraform workspace new production`in the `terraform_templates/GCP` and `terraform_templates/GCP/service_init` folders (or give it a different name and rename the environment in locals_environment accordingly)
- Run `terraform apply` in `GCP/service_init` first (in order to activate the required APIs)
- Run `terraform apply` in `GCP`
- Create the Secret Manager versions on the newly created Secret Manager secrets (create DB user postgres with a password, create the cookie session secret, create the jwt sigining secret)

### AWS

- Modify the property bucket for the Terraform State File in providers.tf to match your bucket name (in this case, it is marble-deployment-state-bucket)
- Run `terraform init`in the `terraform_templates/AWS`
- Set the variables in vars.tf to match your AWS environment
  - aws_key_pair : SSH RSA key pair name to connect to the instances
  - aws_region : AWS region where to deploy the resources
  - aws_zones : List of availability zones to deploy the resources in (in this case, eu-west-1a and eu-west-1b)
  - domain : Domain associated with your certificate in AWS Certificate Manager
- Setup all your environment variables
  - Run `terraform workspace new production`in the `terraform_templates/AWS`
  - Edit the file locals_environments.tf to match your environment variables
    - Firebase : Copy this information for Firebase configuration from your firebase project.
      In the project parameters page, add a application, select configuration and copy all the parameters in the node locals.environments.production.firebase {}
    - Sentry : Copy this information for Sentry configuration from your sentry Admin
    - Domains : Your custom domains for app & api (both defined as CNAME record for `echo $(terraform output --raw alb_url)`
- Setup all your sensitive informations
  - Create a folder named config (gitignored) under `terraform_templates/AWS`
  - Copy in this folder the file credentials.json (Downloaded from Google console and associated to your service account)
  - Genrate a RSA Private key (2048 Bits) and copy its content into a file named private.key
  - Copy all your environment variables and secrets in a file named `environments.private.json` in the `config` folder (see example structure below)

#### Example: `config/environments.private.json`
```json
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

```
- Le fichier `locals_environments.tf` charge désormais ces données via :
  ```hcl
  locals {
    environments = jsondecode(file("${path.module}/config/environments.private.json")).environments
  }
  ```

At the end of the deployment, you should be able to access the application at the URL provided by terraform and set the domain as CNAME record both for your application domain and you api domain

`echo $(terraform output --raw alb_url)`
