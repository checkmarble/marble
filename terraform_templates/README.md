# Using the terraform template examples

## Disclaimer

The terraform templates shared in this folder are purely indicative of what a marble deployment on a GCP environment could look like.
They come wihout guarantee and support. Be advised that a successful deployment may require several rounds of iterative tweaking of ressources/values, as some steps require manual actions to succeed. For instance, the backend service on Cloud Run will only deploy successfully after the relevant secrets versions have been created in GCP Secret Manager (secret versions are not created in terraform so that their values are not stored in the terraform state in plain text).
They are largely inspired from Marble's internal cloud deployment, but while being much simplified to match a "bare bones" deployment needs.

## Usage

- Create a new project
- Create a GCS bucket (in this project, or another) to store the terraform state
- create an admin service account in the project & download a service account key
- Place the downloaded key in the (gitignored) service-account-key folder
- Run `terraform workspace new production`in the `terraform_templates/GCP` and `terraform_templates/GCP/service_init` folders (or give it a different name and rename the environment in locals_environment accordingly)
- Run `terraform apply` in `GCP/service_init` first (in order to activate the required APIs)
- Run `terraform apply` in `GCP`
- Create the Secret Manager versions on the newly created Secret Manager secrets (create DB user postgres with a password, create the cookie session secret, create the jwt sigining secret)
