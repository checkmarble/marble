### :running: **Roadmap**

---
**Marble core features**
- On premise self installation
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

**Planned on roadmap**

- Backtest: check scenario efficiency on your past data before pushing to production
- Supervised Machine Learning: use previous results to create a custom ML detection model
- Advanced connectors for unstructured data: use documents, GPS points, images… in your rules.
  <br><br>
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
- [x] Rule snoozing auditability
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
  - [x] Group decisions in cases by user / account ...
  - [ ] View the environment of a case (linked users / transactions…)
  - [ ] Graph relationship
  - [ ] Set a reminder
- [ ] Case feedback to rule engine
- [x] Workflows decision to case
- [x] Case manager analytics

**Analytics**

- [x] Scenario performance analytics
- [ ] Scenario A/B testing
- [ ] Backtest
      <br>

