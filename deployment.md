# Deploying Marble
## Marble architecture

#### Components
At it's simplest, Marble's software can be described as below:
<img width="3568" alt="Software architecture" src="https://github.com/checkmarble/marble/assets/128643171/781eab91-3027-4683-af0e-73548737747a">

The Marble software is composed of 2 docker images and 3 parts:
1. **[Docker 1]** a back-end API server (go + [gin](https://github.com/gin-gonic/gin)), that serves the internal and public REST APIs
2. **[Docker 1]** a set of cron job scripts (go, run from the same docker image with a different entrypoint as the back-end API server), meant to run periodically
3. **[Docker 2]** a front-end API server (typescript + [Remix](https://remix.run/)), that serves html and exposes actions to the browser

It relies on the existence of a basic set of infrastructure to work:
1. A Postgresql database
2. A scheduler for the cron jobs
3. A set of object storage buckets, to store documents uploaded in the case manager and csv files for batch data ingestion (currently, only Google Cloud Storage: compatibility for ASW S3 and Azure Blob Storage planned soon)
4. A load balancer with TLS termination to expose the APIs
5. A configured Firebase app for end user authentication

#### Marble images
The docker images for Marble are stored on the registry `europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend` and `europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend` for the API respectively.

#### Marble cloud 
For reference, below is a schematic of Marble's cloud offering architecture. It is essentially a variation of the architecture described above, with some infrastructure choices that work well for our cloud offering specifically.
<img width="5400" alt="Software architecture (2)" src="https://github.com/checkmarble/marble/assets/128643171/dedc2c73-ef5a-4fed-bf2f-cb6ee34dc332">
