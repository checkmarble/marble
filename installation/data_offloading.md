## Decision rule execution details offloading

Out of the box, Marble keeps a full audit trace of you decisions by storing not only the result of a rule execution, but also all the intermediate values computed during rule excution from ingested data, aggregates, etc. This allows you to to justify even past decisions in detail, and is also used by the AI agent to review alerts in the case manager in detail.

However, storing those details can quickly create pressure on the database disk as the data is initially stored inline.

### Basic configuration

It is possible to configure Marble to offload this data for a long-term storage outside of the main database, in a bucket storage solution like S3 or GCS. You do this by configuring the environment variables:

- on the background worker: `OFFLOADING_ENABLED` to `true` and `OFFLOADING_BUCKET_URL` to a valid URL of a storage bucket
- on the API server: `OFFLOADING_BUCKET_URL`

The `OFFLOADING_JOB_INTERVAL`, `OFFLOADING_BEFORE`, `OFFLOADING_BATCH_SIZE`, `OFFLOADING_SAVE_POINTS` and `OFFLOADING_WRITES_PER_SEC` may further be configured on the background worker, but the default values should work in most cases. See the Marble deployment guide on Github for more details on those variables. By default, Marble will offload data on decisions older than a week.

### Storage classes

Old decisions are likely to be rarely consulted. For further cost savings, we recommend you configure your blob storage bucket to automatically move the data to long-term storage classes using lifecycle rules. Objects are stored by decision status prefix (`offloading/decision_rules/{status}` where `status` is one of `error`, `hit`, `no_hit`), so it is possible in most blob storage solutions to configure different lifecycle rules for rules that did or did not result in a hit.

Data offloaded to Google Cloud Storage may further use the custom time metadata attribute instead of the object's creation time for lifecycle rules.
As an example, Marble's managed environment moves objects to "Nearline" storage class after a month, "Coldline" after 3 months and "Archive" after a year.
