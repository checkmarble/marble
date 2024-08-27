# Using the terraform template examples

## Disclaimer

The terraform templates shared in this folder are purely indicative of what a marble deployment on a GCP environment could look like.
They come wihout guarantee and support. Be advised that a successful deployment may require several rounds of iterative tweaking of ressources/values, as some steps require manual actions to succeed. For instance, the backend service on Cloud Run will only deploy successfully after the relevant secrets versions have been created in GCP Secret Manager (secret versions are not created in terraform so that their values are not stored in the terraform state in plain text).
They are largely inspired from Marble's internal cloud deployment, but while being much simplified to match a "bare bones" deployment needs.

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
- Set the variables in vars.tf to match your environment
    - aws_key_pair : SSH RSA key pair to connect to the instances
    - aws_region : AWS region where to deploy the resources
    - aws_zones : List of availability zones to deploy the resources in (in this case, eu-west-1a and eu-west-1b)
- Setup all your environment variables 
    - Run `terraform workspace new production`in the `terraform_templates/AWS`
    - Edit the file locals_environments.tf to match your environment variables
        - Firebase : Copy this information for Firebase configuration from your firebase project. 
                     In the project parameters page, add a application, select configuration and copy all the parameters in the node locals.environments.production.firebase {}
        
- Run `terraform apply` in `AWS`

At the end of the deployment, you should be able to access the application at the URL provided by terraform.

`echo $(terraform output --raw alb_url)`