# Version Support Policy

## Database

### PostgreSQL

- Version 16 and above is supported
- The postgis extension must be installed on the database. Most cloud providers handle this, but if you are running your own PostgreSQL you need to do it manually. See the [postgis documentation](https://postgis.net/documentation/getting_started/).

## Search & Sanctions Screening

### Motiva

- We recommend [motiva](https://github.com/apognu/motiva), an open-source, high-performance search engine for screening lists with Marble.
- Version v0.6 is supported with the current version of Marble.

### Yente

- Used for data indexing into Elasticsearch
- The reference implementation of OpenSanctions' search engine for screening lists.
- Version 4.x is required and supported
- Earlier versions are not compatible

---

As well as

### Elasticsearch

- Version 9.2+ is supported
- Specifically tested on Elasticsearch 9.2
- Newer minor versions (9.x) expected to work but not explicitly tested
- Major version changes may require updates

## Version Updates

We recommend:

- Staying within tested version ranges
- Planning upgrades before end-of-support dates
- Testing version upgrades in staging environments first
- Following our upgrade guides when changing versions
