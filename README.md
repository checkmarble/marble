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

The Elastic Licence V2 grants you a non-exclusive, royalty-free, worldwide, non-sublicensable, non-transferable license to use, copy, distribute, make available, and prepare derivative works of the software, subject to the limitations and conditions below.<br><br>
**1) You may not provide the software to third parties as a hosted or managed service, where the service provides users with access to any substantial set of the features or functionality of the software.**<br><br>
2) You may not move, change, disable, or circumvent the license key functionality in the software, and you may not remove or obscure any functionality in the software that is protected by the license key.<br><br>
3) You may not alter, remove, or obscure any licensing, copyright, or other notices of the licensor in the software. Any use of the licensor’s trademarks is subject to applicable law.<br><br>

*See full licence for details*<br><br>

### **✨Features**

---

**Open-source vs licensed**

|                                            | Open-source (Elastic V2) | Licenced by Marble |
| :----------------------------------------: | :----------------------: | :----------------: |
|         Scenario and rule builder          |            ✅            |         ✅         |
|             Real time & batch              |            ✅            |         ✅         |
|                Audit trail                 |            ✅            |         ✅         |
|                Case manager                |            ✅            |         ✅         |
|          Decision & Ingestion API          |            ✅            |         ✅         |
|                   Lists                    |            ✅            |         ✅         |
|                 Workflows                  |            ❌            |         ✅         |
|                    SSO                     |            ❌            |         ✅         |
|              Role management               |            ❌            |         ✅         |
|                  Webhooks                  |       Partial            |         ✅         |
|                 Test mode                  |            ❌            |         ✅         |
| Direct tech support with SLA & hot patches |            ❌            |         ✅         |
|       Rule snoozing by end customer        |            ❌            |         ✅         |
|             Community support              |            ✅            |         ✅         |
| Rights to use for 3rd party services       |            ❌            |         ✅         |

---

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

### :running: **Roadmap**

---

We're transparent on what we're working on, see [here](https://github.com/checkmarble/marble/tree/main/roadmap)

### 🕵 **How to use Marble**

---

You will find a functional documentation of how to use Marble [here](https://docs.checkmarble.com/docs/what-is-marble-copy), and the documentation of our public API [here](https://docs.checkmarble.com/reference/intro-getting-started).

### 🔧 **How to Install Marble**

---

Want to deploy Marble on your environement? Check our ressources [here](https://github.com/checkmarble/marble/tree/main/installation)

### 🐧 **Why Open Source?**

---

**We need your ⭐️**

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

- Leave us a ⭐️
- Give us feedback in our Slack community
- Help with bugs and features on our Issues page
- Submit a feature request or bug report
  <br><br>

### Contact us

Reach out to us on our website, on our [slack](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw), or ask for a demo [here](https://calendly.com/arnaudschwartz/discover-marble-1).

Made with :heart: in :fr: by Marble
