[![Better Stack Badge](https://uptime.betterstack.com/status-badges/v1/monitor/1ybu2.svg)](https://marble.betteruptime.com/)
![Cover image of Marble, the open source monitoring platform for fraud prevention and AML compliance](https://github.com/user-attachments/assets/c6d42921-fc76-4d7d-85d4-4ecf212a3ca8)

# Marble
**The best of Build and Buy: keep full control and build on top.**

Marble is the flexible alternative to Comply Advantage, Actimize or Fiserv for Transaction Monitoring, AML Screening and Case investigation powered by AI.
Our Open Source core provides the flexibility to deploy On-Premise or SaaS.

It is already used by 100+ fast growing fintechs, banks and top crypto exchanges in 15+ countries in the world.

> What I like the most about Marble is **Flexibility**. In other tools, you don't understand what is going on behind the scenes which ends up lacking precision and possibilities to troubleshoot your detection programs.  
> With Marble everything is transparent. You can basically do anything you want, **with all your data**.  

*Alexander Legoshin, Founder at Gemba*

[Slack](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw) - [Website](https://www.checkmarble.com/) - [Demo](https://www.checkmarble.com/watch-a-demo)


## The fraud & compliance monitoring platform, bespoke as if built in-house, without the burden
- Get Real-time Transaction Monitoring tailored to your business
- Screen Customers, Companies and Payments against global sanction and PEP lists
- Monitor customers continuously
- Streamline and automate investigations with AI
- Designed to adapt to any new activities and regulatory requirements

**Open-source, open architecture:**
- **Flexible**: Connect Marble to any of your internal systems or tools, such as transaction databases, KYC solutions, or 3rd party data providers.
- **Pricing**: We offer a free open source self-hosted option and a licensed option with Enterprise features which can be deployed Self-hosted or SaaS.
- **Privacy**: With the Self-hosted option, your data never has to leave your infrastructure.

*NB: We do not provide KYC services. There are plenty of awesome players in the market that you can connect with Marble* 🙂

[<img width="500" alt="See Marble in action in our interactive demo" src="https://github.com/user-attachments/assets/3f31bdab-450d-486b-bc96-1c77799599a5" />](https://www.checkmarble.com/watch-a-demo)


## ✨ Features
- **Transaction monitoring**: real time or post trade, based on a custom data model that mirrors your data warehouse and integrates with any core banking and 3rd party tools.
- **Customer and Company Screening**: screen against sanctions, PEP and adverse media lists with high quality lists updated multiple times a day, real-time or scheduled
- **Continuous Monitoring**: keep your customers continuously checked against the latest lists of your choice, without adding manual workload.
- **Investigation suite**: investigate alerts in one unified case manager to explore, annotate & act without context switching.
- **AI Automation & Assistance**: leverage AI to streamline manual tasks in rule building, detection program optimization and investigation.
- **Reporting & BI**: embedded analytics to monitor performance or detection programe and investigation workflows, direct database access for your BI tools.
- **Audit Trail**: searchable and unalterable audit logs and audit trails for detection program, Workflows and Case Actions.
- **Enterprise-grave Governance & security**: Role-based Access Control, SSO with Open ID Connect, IP whitelisting, SOC 2 Type II certification
- **Community & Support**



## 🚀 Quick start
Get up and running quickly to have a first sense of what Marble is:

### Prerequisites

- Docker and Docker Compose
- Git
- 4GB RAM minimum
- 10GB disk space

### Basic Installation

```jsx
# 1. Clone the repository
git clone <repository-url>
cd marble

# 2. Copy example environment file
cp .env.dev.example .env.dev

# 3. Start Marble
docker compose -f docker-compose-dev.yaml --env-file .env.dev.example up
```

➡️ Access to the full [Installation guide](https://github.com/checkmarble/marble/tree/main/installation) to install and deploy Marble.



## 💡 Getting the most out of Marble
- Go through our [interactive demo](https://www.checkmarble.com/watch-a-demo) to see Marble in action;
- Read the [documentation](https://docs.checkmarble.com/docs/what-is-marble) on how to use Marble to learn more about all the features;
- Check the [documentation](https://docs.checkmarble.com/reference/intro-getting-started) of our public API
- Join our [Slack community](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw) if you need help, or want to chat, we’re here to help;
- Register to [Marble RegTech Digest](https://www.checkmarble.com/newsletter-registration) the monthly newsletter where our experts analyse the future of FinCrime, Regulation, and the tech built to grow with;
- [Book a quick meeting](https://www.checkmarble.com/talk-to-an-expert) to speak with an expert.




## 🧑‍💻 Contributions and development environment
We want to create an open environment and appreciate all types of contributions that benefits all current and future users. 

Here are some ways you can contribute:

- Leave us a ⭐️
- Give us feedback in our [Slack community](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw)
- Follow this [guide](https://github.com/checkmarble/marble/blob/main/installation/test_run.md) to set up a Marble development environment on your machine. It is intended for people willing to contribute to Marble.
- Help with bugs and features on our [Issues page](https://github.com/checkmarble/marble/issues)
- Submit a feature request or bug report

Made with ❤️ in 🇫🇷 by Marble
