![GITHUB](https://github.com/checkmarble/marble/assets/130587542/f5b6e99c-9e26-4c92-a6d4-37d7ea4b900e)

Marble is an open-source Transaction, Event, and User real-time engine designed to help companies detect money laundering, service abuse or fraud behavior.

We provide an easy-to-use rule builder that can leverage any type of data, an engine capable of running checks in batch or in real-time, and a case manager to improve operational efficiency.

Marble is beneficial for payment service providers (PSPs), banking-as-a-service (BaaS) providers, neo banks, marketplaces, telecommunications companies... It allows them to quickly set up and update detection scenarios that generate decisions within minutes.

These decisions can trigger events in your systems, introduce friction, or restrict operations in real-time. They can also be investigated within Marble using our case manager or in your own system by utilizing our API.

Marble is developed with compliance requirements in mind, ensuring that everything is versioned and auditable without any time limitations.

**Open-source, open architecture:**

- Composable: Connect Marble to any of your internal systems or tools, such as transaction databases, KYC solutions, or 3rd party data providers.
- Pricing: Our self-hosted version is free. Our cloud version is priced like a SaaS and is surprisingly cheaper than market leaders.
- Privacy: Your data never has to leave your infrastructure.

NB: We do not provide KYC services. There are plenty of awesome players in the market that you can connect with :)
<br>
<img width="600" alt="Rule example" src="https://github.com/checkmarble/marble/assets/130587542/e4016997-9329-49ed-b62f-266b911367e2" class="center">
<br><br>

### **🔖 License**

---

[Elastic License 2.0 (ELv2)](./LICENSE)

### **✨Features**

---

**Marble core features**

- Create detection scenarios based on rules.
- Run those scenarios in batch or real-time to generate decisions.
- Investigate decisions in your own system or within Marble's case manager.
- Manage custom lists such as known users, VPN IPs, and keywords.
- Create any type of data model to feed into Marble.

**Released** (overview)

- Rule engine: executes detection scenarios in batch or real-time.
  - Batch run: can be scheduled or run on-demand.
  - Real-time: triggered through an API.
- Data management: allows you to create your own data model for using Marble.
  - Data interface: set up and describe the objects you want to send to Marble.
  - Ingestion API: send any data to Marble.
- Rule builder: easily create detection scenarios using a user-friendly interface.
  - Create scenarios.
  - Create rules.
  - Score-weighted final decision.
- Lists: create internal lists and keep them updated for use in rules.
- Case management: investigate decisions and create escalations.
  - View decisions.
  - Investigate a case.
- User management.

**In development**

- On-premise self-installation

**Planned on roadmap**

- Backtest: check scenario efficiency on your past data before pushing to production
- Supervised Machine Learning: use previous results to create a custom ML detection model
- Advanced connectors for unstructured data: use documents, GPS points, images… in your rules.
  <br><br>

#### Premium features

The core of the decision engine is available in open-source, but some advanced features are only accessible with a lincense (in our cloud offering or on-premise). You can find the list of available features in our [pricing page](https://www.checkmarble.com/pricing).

As long as you are runnig Marble locally with a test setup (using the Firebase auth emulator for end user authentication), you will see all the features, but you will be restricted if you authenticate with a real Firebase auth app.

### 💭 **Example Use Cases**

---

Marble's incredible flexibility is due to its fully open data model. Here are some applications already in use with Marble:

- Transaction monitoring for financial institutions (AML & fraud), supporting every type of payment scheme (including the exotic ones: Marble handles any type of data).
- User/account monitoring.
- User risk score calculation at onboarding and throughout their lifecycle.
- Event scoring: adding new beneficiaries, subscribing to new products, etc.
- Vendor/buyer checks for marketplaces: return abuse, fake transactions, etc.
- Condition abuse: robocalling for telecom companies, bot management on social networks and apps.
- Embedded in financial SaaS: fine control of expenses for end users.

Feel free to try other use cases and let us know! We'd love to hear from you.

### 🔧 **How to Install Marble**

---

> The following instructions are for a docker-compose setup. You can also take inspiration from the terraform templates provided in the repository to create a serverless GCP deployment of Marble, inspired by Marble's own cloud deployment.

Simply clone this repository and run `docker compose --env-file .env.example up` (customize the .env-example file or provide your own copy).
It will run out of the box with the firebase auth emulator. If you wish to run Marble open-source in production, you will need to create a firebase auth app.

The first time you run the code, you should enter an organization name and organization admin user email to create using the `CREATE_ORG_NAME` and `CREATE_ORG_ADMIN_EMAIL` environment variables. Unless using the firebase emulator, you must enter an actual email address that you own so that you may verify it and login with firebase. You can always create new organizations later using the same procedure.

In a local demo setup:

> In a local test setup (meaning if you are running with the firebase auth emulator), the License key is not required. You can leave it empty. The full feature set is available.

- just run the docker-compose as it is, it should work
- give the firebase emulator a moment to get started, it's a bit slow when first launched
- create a Firebase user with the email you provided in the `CREATE_ORG_ADMIN_EMAIL` environment variable (you can do this on the Marble login page by using the SSO button or sign up with email)

In a production setup:

- set the `FIREBASE_AUTH_EMULATOR_HOST_SERVER` and `FIREBASE_AUTH_EMULATOR_HOST_CLIENT` env variables to empty strings in your .env file
- create a Firebase project and a Firebase app, and set the relevant env variables (`FIREBASE_API_KEY` to `FIREBASE_APP_ID` as well as `GOOGLE_CLOUD_PROJECT`) in your .env file
- if you plan to use the batch ingestion feature or the case manager with file storign feature, make sure you create the Google Cloud Storage buckets, set the corresponding env variables and run your code in a setup that will allow default application credentials detection
- create a Firebase user with the email you provided in the `CREATE_ORG_ADMIN_EMAIL` environment variable (you can do this on the Marble login page by using the SSO button or sign up with email)
- if you have a license key, set it in the `LICENSE_KEY` env variable in your .env file

Open the Marble console by visiting `http://localhost:3000`, and interact with the Marble API at `http://localhost:8080` (assuming you use the default ports). Change those values accordingly if you configured a different port or if you are calling a specific host.

### 🕵 **How to use Marble**

---

You will find a functional documentation of how to use Marble [here](https://docs.checkmarble.com/docs/what-is-marble-copy), and the documentation of our public API [here](https://docs.checkmarble.com/reference/intro-getting-started).

### 🐧 **Why Open Source?**

---

Risk management is challenging for many companies. Currently, you can either:

- Build your own risk infrastructure:
  - It’s a never-ending task.
  - Building from scratch takes months and often falls short of end-user expectations.
  - Essential elements like versioning and audit trails are often overlooked.
  - Risk teams need updates urgently, but development teams need to scope and prioritize first.
- Or, spend a significant amount to buy a service where:
  - Setup costs and time are substantial.
  - You might lack full control over the applied rules.
  - The scoring algorithm is “proprietary,” meaning you can’t explain it.
  - There’s limited flexibility to connect your data and product specifics, such as limited payment schemes covered.
  - Contract renewal is burdensome.

Marble offers a clear third option:

- Start Strong: Benefit from one of the best engines on the market for free. There’s no excuse for not having top-notch monitoring from day one.
- Privacy: Your data remains yours, always.
- Total Transparency: The code is open; you can see everything within the engine. You KNOW why an alert is raised every time; you don’t have to guess.
- Evolutivity: Use any data you want and evolve the model instantly. Adding a new product, even with a never-before-seen payment scheme, takes minutes.
- Community Driven: Contribute based on your needs: need a custom calculation? A third-party integration? It’s just a commit away.
  <br><br>

### :sparkling_heart: **Contributing**

---

We want to create an open environment and appreciate all types of contributions that benefits all current and future users. Here are some ways you can contribute:

- Give us feedback in our Slack community
- Help with bugs and features on our Issues page
- Submit a feature request or bug report
  <br><br>

### :running: **Roadmap**

---

**High level roadmap**

Opensource - self installation

- [x] Docker for GCP
- [x] Docker for AWS
- [ ] Docker for Azure

**Rule Engine :**

- [x] Realtime decision through API
- [x] Scheduled batch decisions
- [x] On-demand batch decisions

**Rule builder**

- [x] Create and update a scenario
- [x] Create and update lists
- [x] No code rule creation
- [x] Create Rules with group (OR) and conditions (AND)
- [x] Associate a score weight with each rule
- [ ] Aggregate creation
  - [x] Use aggregates to manage one to many relations and searchs
  - [x] Duplicate agregates
  - [ ] Nest agregates
- [ ] Connectors
  - [x] Boolean connectors (>,<,=,<>…)
  - [x] Text connectors (is in, is not in, contains, contains partially)
  - [x] Date connectors (before, within…)
  - [x] Nesting (sub-calculation within a single rule line)
  - [ ] Previous results use (Has been flagged previously by)
  - [ ] Unstructured data connectors (document contains, distance between GPS points…)
  - [x] Fuzzy text connectors (is close to…)
- [x] Score based decision
- [ ] Supervised learning
  - [ ] ML model creation
  - [ ] ML model test

**Data**

- [x] Define data model with objects and fields
  - [x] Define Enums
  - [x] Non-breaking update of data model
  - [ ] Breaking update of data model
- [x] Ingestion API
- [ ] Zapier connector for 3rd party

**Audit**

- [x] Scenario, data and list versioning
- [ ] Front-accessible run logs

**Case management**

- [x] Manage
  - [x] Create inboxes
  - [x] Create tags
  - [x] Create users
- [ ] **Case investigation**
  - [x] Create a case from a decision or from scratch
  - [x] Associate multiple decisions to a case
  - [x] Add commentary to a case
  - [x] Add documents
  - [x] View timeline
  - [ ] View the environment of a case (linked users / transactions…)
  - [ ] Graph relationship
  - [ ] Set a reminder
- [ ] Case feedback to rule engine
- [x] Case manager analytics

**Analytics**

- [x] Scenario performance analytics
- [ ] Scenario A/B testing
- [ ] Backtest
      <br>

### Contact us

Reach out to us on our website, on our [slack](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw), or ask for a demo [here](https://calendly.com/arnaudschwartz/discover-marble-1).

Made with :heart: in :fr: by Marble
