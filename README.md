
![logo-modified](https://github.com/checkmarble/marble/assets/130587542/d4f9f4ea-eaf0-442c-99fb-e3ce4811fdeb)



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

### :thought_balloon: Example of use cases

---

Marble is incredibly felxible thanks to its fully open data model. Here are a few application already happening with Marble :

- transaction monitoring for financial institution (AML & fraud), for every type of payement scheme (even the ones really exotic : Marble handles any type of data)
- User / account monitoring
- User risk score calculation at onboarding or during its lifecycle
- Event scoring : adding new beneficiary, subscribing to a new product...
- Vendor / buyer checks for marketplaces : return abuse, fake transactions...
- Condition abuse : robocalling for telco, bot management on social networks and apps
- Embeded in a financial SaaS : fine control of expenses for end users
  Feel free to try other use cases and let us know ! We'd love to hear from you.

<br><br>

### :wrench: How to install Marble

---

_coming soon_
<br><br>

### :penguin: **Why Open Source?**

---

Risk management is broken for many companies. Currently you can either :

- Build your own risk infrastructure :

  - It’s a never-ending work
  - Building from the ground up takes months, and is usually sub-par with expectations end-users expectations
  - You usually miss non user essential key elements, like versioning and audit trails
  - Risk teams need their updates ASAP, but dev teams need to scope and prioritize first

- Or you have to spend hundreds of thousands to buy a service where :
  - Set up cost and time are significant
  - You might not have total control over the rules applied
  - The scoring algorithm is “proprietary” which means you can’t explain it
  - There’s limited flexibility to connect your data and product specifics : limited payment schemes covered for eg.
  - Contract renewal is a pain

**Marble provides a clear 3rd path :**

- **Start great** : You can benefit from one of the best engines on the market for free. There’s no excuse for not having great monitoring even from day 1.
- **Privacy :** Your data stays your own, forever
- **Total transparency:** the code is open, you can see everything happening within the engine. You KNOW why there’s an alert or not every time, you don’t guess.
- **Evolutivity:** You can use any data you want, and evolve the model in a second. Adding a new product, even with a payment scheme never seen before, takes minutes.
- **You are part of it :** You can contribute, based on your needs: need a custom calculation? a 3rd party integration? it’s a commit away.
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

- [ ] Docker for GCP
- [ ] Docker for AWS
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
  - [ ] Fuzzy text connectors (is close to…)
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
- [ ] Case manager analytics

**Analytics**

- [ ] Scenario performance analytics
- [ ] Scenario A/B testing
- [ ] Backtest
      <br>

### Contact us

Reach out to us on slack, on our website, or ask for a demo [here](https://calendly.com/arnaudschwartz/discover-marble-1).

Made with :heart: in :fr: by Marble
