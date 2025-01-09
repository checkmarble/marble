# Deploying Marble

## Marble architecture

#### Components

The typical architecture of a self-hosted Marble deployment is as below:
<img width="3568" alt="Deployment architecture" src="https://github.com/user-attachments/assets/80d7a9d3-10d0-4a14-ac14-d6badcc5393d">

The corresponding functional architecture is the following:
<img width="3568" alt="Deployment architecture" src="https://github.com/user-attachments/assets/d9b85e87-532c-4efc-9367-b63eaf93a2da">

The Marble software is composed of 2 docker images and 3 parts:

1. **[Docker 1]** a back-end API server (go + [gin](https://github.com/gin-gonic/gin)), that serves the internal and public REST APIs
2. **[Docker 1]** a set of cron job scripts (go, run from the same docker image with a different entrypoint as the back-end API server), meant to run periodically
3. **[Docker 2]** a front-end API server (typescript + [Remix](https://remix.run/)), that serves html and exposes actions to the browser

It relies on the existence of a basic set of infrastructure to work:

1. A Postgresql database
2. A scheduler for the cron jobs
3. A set of object storage buckets, to store documents uploaded in the case manager and csv files for batch data ingestion (compatible with Google Cloud Storage, AWS S3 and Azure Blob Storage)
4. A load balancer with TLS termination to expose the APIs
5. A configured Firebase app for end user authentication

#### Marble images

The docker images for Marble are stored on the registry `europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend` and `europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend` for the API respectively.

#### Marble cloud

For reference, below is a schematic of Marble's cloud offering architecture. It is essentially a variation of the architecture described above, with some infrastructure choices that work well for our cloud offering specifically.
<img width="5400" alt="Software architecture (2)" src="https://github.com/user-attachments/assets/03f135e2-aef4-44a0-90cd-ffc15bdf6bbc">

## Deploy Marble serverless

Here at Marble, we choose to deploy our code on a serverless infrastructure. We do this to leverage the full ease of use, flexibility and scalability of GCP's Cloud Run offering.
Doing this, we choose to run the back-end API server and the cron jobs (which are run with different flags from the same docker image) separately:

- the API is a Cloud Run service
- the scripts are run as distinct Cloud Run Jobs, scheduled by a Cloud Scheduler

_Technically_ we could have the cron jobs scheduled within the same container that is running the API service, but we avoid this for the following reasons:

- we don’t want a batch job to be stopped/to fail because an api instance is torn down
- we don’t want the api to be impacted by a batch job’s cpu/memory usage
- the cloud run API has limits in how long it can take at most to handle requests (which are shorter than the typical cron job execution time)

However, running it all together could make sense if Marble is run in a VM, more on this below.

Moreover, in our cloud deployment, we use Google Secret Manager (integrated with Cloud Run) to inject secrets as environment variables into the containers, and a GCP application load balancer for load balancing, TLS termination, DDoS protection and other security rules.

In this repository, we provide an example set of terraform files that you can adapt to deploy Marble serverless in your own GCP environment.
We have also received community contributions giving an example set of terraform files for deploying Marble in managed containers on AWS.
It should also be reasonably simple to run an equivalent deployment on Azure Container Instances + scheduler on Azure.

## Deploy Marble on a VM

While Marble on a VM is not ideal for our cloud offering, it may make sense for an open-source or on-premise usecase. If you do so, you can run the back-end API and built-in go scheduler together by passing the `--server --cron` arguments to the docker container.

## Deploy Marble on Kubernetes

While we do not currently provide support for deploying Marble on Kubernetes, it should work very similarly to a serverless deployment. You can schedule the cron jobs by using Kubernetes' built-in scheduling tool.

# Deploy Marble outside of GCP

Marble relies on Firebase Authentication (a part of Google's web app deployment toolbox) for authentication. This means that, even if you are running Marble in another cloud provider's cloud, or in your own infrastructure, you need to create a Firebase app, as well as a service account key to access it from the backend container.
In practice, any usage of Marble should fall under the Firebase Auth free plan, though you may still need to provide a credit card number.
