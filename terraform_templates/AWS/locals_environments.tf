locals {
  environments = jsondecode(file("${path.module}/config/environments.private.json")).environments
}
