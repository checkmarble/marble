# Introduction

This repo is the marble platform instanciated via kubernetes. it helps to deploy locally, or on a cloud provider the kubernetes platform of the marble application

## Getting Started

### Setup your environment

for this to work, you need the following components

- [Install Docker](https://docs.docker.com/engine/install/)  in order to be able to deploy a kubernetes cluster via kind.
- [Install Kubectl](https://kubernetes.io/docs/tasks/tools/) to perform some advanced commands on a kubernetes cluster
- [Install Helm](https://helm.sh/docs/intro/install/) which is the package manager for kubernetes
- [Install Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) for running local kubernetes clusters using 
docker containers
- [Install yq](https://github.com/mikefarah/yq/#install) used by the makefile to manipulate yaml files



### Install the application

In order to install the marble application and its dependencies you need to do the following

#### Create the kubernetes cluster

the creation of the kubernetes cluster is done by using the kind tool that you have installed previously. we will use the file `kind-cluser-config.yaml` in order to define the structure of our cluster, which is composed of 1 control plane, and 2 workers.
````yaml
# three node (two workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
````
- execute the command `make create_cluster`:
This command will  create a kubernetes cluster named `marble` using the configuration file `kind-cluser-config.yaml`. check the `Makefile` for more details
- once the creation is done, you can check that the cluster has been created successfully using the command `kubectl cluster-info --context kind-marble`
which should give you a result similar to the one below

````sh
Kubernetes control plane is running at https://127.0.0.1:62533
CoreDNS is running at https://127.0.0.1:62533/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
````
Once the cluster is created, make sure the next commands will use the newly created cluster. execute the command `make list_k8s-contexts` which should give you the following result
````
CURRENT   NAME             CLUSTER          AUTHINFO               NAMESPACE
          do-fra1-isupo    do-fra1-isupo    do-fra1-isupo-admin
*         kind-marble      kind-marble      kind-marble
````
the star means the current kubectl command will be applied on this cluster which is the one we created earlier.

#### Upload images to the local cluster

In order to deploy the helm packages, the associated images must be available on the newly created cluster. So we must upload the images to the cluster by executing the command `make upload_images`


#### Deploy the application

to deploy the application, just run `make install`. It will deploy the marble application on your cluster named `marble` with the dependencies needed. 

## Uninstall

### Uninstall marble-app
In order to uninstall the app, execute the command `make uninstall`.

### Delete the cluster
In order to delete the cluster, execute the command `make delete_cluster`

# Execute github workflows locally

If you want to execute the github workflow locally, you need to install [act tool](https://nektosact.com/installation/index.html).

Then run the command `act --container-architecture linux/amd64  --var-file myfolder/var_file --secret-file myfolder/secret_file` . the option `--var-file` is to define variables that will be used during the execution of the github workflow; you can change and add your own var file; the current one is for demo purpose only. the same logic applies for the `--secret-file` option.

## Vars and Secrets expected by the github workflow

### Vars
- `ARTIFACT_REGISTRY_HOST_NAME` : example `myregion-west1-docker.pkg.dev`
- `ARTIFACT_REGISTRY_REPOSITORY`
- `INFRA_PROJECT_ID`
- `ACCOUNT`
- `CHART_VERSION`
- `CHART_NAME`

### Secrets
 - `GCP_SA_KEY`: used for authenticating to the google cloud platform below and example
````json
GCP_SA_KEY={"type": "service_account","project_id": "tokyo-country-381508","private_key_id": "my_priv_key_id","private_key": "-----BEGIN PRIVATE KEY-----\nprivate\n-----END PRIVATE KEY-----\n","client_email": "my-test-service-acc@tokyo-country-381508.iam.gserviceaccount.com","client_id": "myClientID","auth_uri": "https://accounts.google.com/o/oauth2/auth","token_uri": "https://oauth2.googleapis.com/token","auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-test-service-acc%40tokyo-country-381508.iam.gserviceaccount.com","universe_domain": "googleapis.com"}
````
- `KEY_FILE`: used to authenticate to the google artifact registry. here below is an example
````json
{
    "type": "service_account",
    "project_id": "paris-country-381508",
    "private_key_id": "56b8ba677bc93f7f708e193d4110842b9755555",
    "private_key": "privkey",
    "client_email": "my-test-service-acc@tokyo-country-381508.iam.gserviceaccount.com",
    "client_id": "109620801848095890203",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-test-service-acc%paris-country-381508.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
````

This action is part of the workflow and in order for this to work, you need to provide a key.json file, that mus

# The version file `.versions`

the version file is used to define which version of the back/front-end will be deployed. it is presented as follow
````bash
MARBLE-FRONT-IMG=v0.1.24
MARBLE-FRONT-VERSION=0.2.1
MARBLE-BACK-IMG=v0.1.22
MARBLE-BACK-VERSION=0.2.2
APPLICATION-VERSION=0.2.0
````
- MARBLE-FRONT-IMG: reprensents the docker image version for the frontend application
- MARBLE-FRONT-VERSION: reprensents the target version of the helm package for the frontend application
- MARBLE-BACK-IMG: reprensents the docker image version for the backend application
- MARBLE-BACK-VERSION: reprensents the target version of the helm package for the backend application

once modified, this file will be used when builind and publishing the helm package of the marble application. here is how to use it

- Change the docker image version or the helm package version in the `.versions` file
- Launch the github workflow or if you want to test, you can execute the makefile target `update_dependencies`. It will use the `.versions`file to update the versions of the different dependencie, as described in the `.versions`file.