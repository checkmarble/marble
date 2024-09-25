### 🔧 **How to Install Marble**

---

> The following instructions are for a docker-compose setup. You can also take inspiration from the terraform templates provided in the repository to create a serverless GCP deployment of Marble, inspired by Marble's own cloud deployment.

Simply clone this repository and run `docker compose --env-file .env.example up` (customize the .env-example file or provide your own copy).
It will run out of the box with the firebase auth emulator. If you wish to run Marble open-source in production, you will need to create a firebase auth app.

The first time you run the code, you should enter an organization name and organization admin user email to create using the `CREATE_ORG_NAME` and `CREATE_ORG_ADMIN_EMAIL` environment variables. Unless using the firebase emulator, you must enter an actual email address that you own so that you may verify it and login with firebase. You can always create new organizations later using the same procedure.

> `CREATE_GLOBAL_ADMIN_EMAIL` is optional. It is useful if you want to access cross organization data. If you provide it, the user will be created as a global admin. It must be different from `CREATE_ORG_ADMIN_EMAIL`.

**In a local demo setup:**

> In a local test setup (meaning if you are running with the firebase auth emulator), the License key is not required. You can leave it empty. The full feature set is available.

- just run the docker-compose as it is, it should work
- give the firebase emulator a moment to get started, it's a bit slow when first launched
- create a Firebase user with the email you provided in the `CREATE_ORG_ADMIN_EMAIL` environment variable (you can do this on the Marble login page by using the SSO button or sign up with email)

**In a production setup:**

- set the `FIREBASE_AUTH_EMULATOR_HOST_SERVER` and `FIREBASE_AUTH_EMULATOR_HOST_CLIENT` env variables to empty strings in your .env file
- create a Firebase project and a Firebase app, and set the relevant env variables (`FIREBASE_API_KEY` to `FIREBASE_APP_ID` as well as `GOOGLE_CLOUD_PROJECT`) in your .env file
- if you plan to use the batch ingestion feature or the case manager with file storign feature, make sure you create the Google Cloud Storage buckets, set the corresponding env variables and run your code in a setup that will allow default application credentials detection
- create a Firebase user with the email you provided in the `CREATE_ORG_ADMIN_EMAIL` environment variable (you can do this on the Marble login page by using the SSO button or sign up with email)
- if you have a license key, set it in the `LICENSE_KEY` env variable in your .env file

**Firebase authentication:**

In a production setup, you need to authenticate to GCP to use Firebase and Cloud Storage. If you are not running the container directly in a GCP environment, here is how you could do this:

- create a volume attached to the marble-api container (see the )
- place the json service account key for GCP in the local shared folder (or otherwise inject it into the docker container, depending on how you run Marble)
- set the `GOOGLE_APPLICATION_CREDENTIALS` variable equal to the path to the service account key

Open the Marble console by visiting `http://localhost:3000`, and interact with the Marble API at `http://localhost:8080` (assuming you use the default ports). Change those values accordingly if you configured a different port or if you are calling a specific host.

#### **How to upgrade your Marble version**

You upgrade your Marble version by checking out the release of your choice, and simply running it. By running the docker image with the options `"--server", "--migrations"`, you execute the database migrations of the version and then start the server again.

If you are running in a production environment, remember that while the migrations are running, your server will not be responding. You should preferably upgrade your version outside of the busy hours of the week.

You should always increase the version of Marble one version at a time, giving the time to version N to migrate and deploy before you upgrade to version N+1.
