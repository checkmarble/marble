Marble is an open-source Transaction, Event, and User real-time engine that helps companies detect money laundering, service abuse or fraud behavior. 

We provide an easy-to-use rule builder that can leverage any type of data, an engine capable of running checks in batch or in real-time, and a case manager to improve operational efficiency. 

Marble helps PSPs, BaaS, neo banks, marketplaces, and telcos… to set and update detection scenarios in minutes that will generate decisions. 

Those decisions can be used to trigger events in your systems, add frictions, or limit operations in real-time. They can also be investigated either within Marble using our case manager or in your own system by leveraging our API

Marble is built with compliance constraints in mind: everything is versioned and auditable without time limitations. 


**Open-source, open architecture:**

- Composable: connect Marble to any of your internal systems or tools (Transaction database, KYC solution, 3rd party data providers);
- Pricing: Our self-hosted version is free. Our cloud version is priced like a SaaS, and surprisingly cheaper than market leaders :)
- Privacy: your data never has to leave your infrastructure.

NB : we’re not providing KYC services. There’s plenty of great players on the market we can connect with :) 


### **🔖 License**
---

Marble is available under ELv2 licence

The license terms are available here :

[Licence terms](https://www.notion.so/Licence-terms-c07343af9e264ac2835d2169f88cfeed?pvs=21)


### **✨Features**
---

**Marble core features** 

- Create detection scenarios based on rules
- Run those scenarios in batch or real-time, generation decisions
- Investigate decision in your own system or within Marble’s case manager
- Manage custom lists : known users, VPN IPs, keywords…
- Create any type of data model to feed into Marble

**Released** (overview)

- Rule engine: runs the detection scenarios in batch or in real-time
    - Batch run : scheduled or on-demand
    - Real-time: triggered by API
- Data management: create your own data model to use Marble
    - Data interface: set up and describe the objects you want to send into Marble
    - Ingestion API : send any data into Marble
- Rule builder : Build detection scenarios with an easy-to-use interface
    - Create scenarios
    - Create Rules
    - Score-weighted final decision
- Lists : Create internal lists and update them to use in Rules
- Case management : Investigate decisions and create escalations
    - View decisions
    - Investigate a case
- User management

**In development**

- On-premise self-installation

**Planned on roadmap**

- Backtest: check scenario efficiency on your past data before pushing to production
- Supervised Machine Learning: use previous results to create a custom ML detection model
- Advanced connectors for unstructured data: use documents, GPS points, images… in your rules.

### How to install Marble
---
/coming soon/


### **Why Open Source?**
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
- **Evolutivity:**  You can use any data you want, and evolve the model in a second. Adding a new product, even with a payment scheme never seen before, takes minutes.
- **You are part of it :** You can contribute, based on your needs: need a custom calculation? a 3rd party integration?  it’s a commit away.


### **Contributing**
---

We want to create an open environment and appreciate all types of contributions that benefits all current and future users. Here are some ways you can contribute:

- Give us feedback in our Slack community
- Help with bugs and features on our Issues page
- Submit a feature request or bug report


### **Roadmap**
---

**High level roadmap**

Opensource

- [ ]  Docker for GCP
- [ ]  Docker for AWS
- [ ]  Docker for Azure

**Rule Engine :** 

- [x]  Realtime decision through API
- [x]  Scheduled batch decisions
- [x]  On-demand batch decisions

**Rule builder**

- [x]  Create and update a scenario
- [x]  Create and update lists
- [x]  No code rule creation
- [x]  Create Rules with group (OR) and conditions (AND)
- [x]  Associate a score weight with each rule
- [ ]  Aggregate creation
    - [x]  Use aggregates to manage one to many relations and searchs
    - [x]  Duplicate agregates
    - [ ]  Nest agregates
- [ ]  Connectors
    - [x]  Boolean connectors (>,<,=,<>…)
    - [x]  Text connectors (is in, is not in, contains, contains partially)
    - [x]  Date connectors (before, within…)
    - [x]  Nesting (sub-calculation within a single rule line)
    - [ ]  Previous results use (Has been flagged previously by)
    - [ ]  Unstructured data connectors (document contains, distance between GPS points…)
    - [ ]  Fuzzy text connectors (is close to…)
- [x]  Score based decision
- [ ]  Supervised learning
    - [ ]  ML model creation
    - [ ]  ML model test

**Data**

- [x]  Define data model with objects and fields
    - [x]  Define Enums
    - [x]  Non-breaking update of data model
    - [ ]  Breaking update of data model
- [x]  Ingestion API
- [ ]  Zapier connector for 3rd party

**Audit**

- [x]  Scenario, data and list versioning
- [ ]  Front-accessible run logs

**Case management**

- [x]  Manage
    - [x]  Create inboxes
    - [x]  Create tags
    - [x]  Create users
- [ ]  **Case investigation**
    - [x]  Create a case from a decision or from scratch
    - [x]  Associate multiple decisions to a case
    - [x]  Add commentary to a case
    - [x]  Add documents
    - [x]  View timeline
    - [ ]  View the environment of a case (linked users / transactions…)
    - [ ]  Graph relationship
    - [ ]  Set a reminder
- [ ]  Case feedback to rule engine
- [ ]  Case manager analytics

**Analytics**

- [ ]  Scenario performance analytics
- [ ]  Scenario A/B testing
- [ ]  Backtest


### Contact us

Reach out to us on slack, on our website, or ask for a demo [here](https://calendly.com/arnaudschwartz/discover-marble-1).

# marble

