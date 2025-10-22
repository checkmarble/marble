## Decision rule execution details offloading

Out of the box, Marble keeps a full audit trace of you decisions by storing not only the result of a rule execution, but also all the intermediate values computed during rule excution from ingested data, aggregates, etc. This allows you to to justify even past decisions in detail, and is also used by the AI agent to review alerts in the case manager in detail.

However, storing those details can quickly create pressure on the database disk as the data is initially stored inline.

### Basic configuration

It is possible to configure Marble to offload this data for a long-term storage outside of the main database, in a bucket storage solution like S3 or GCS. You do this by configuring the environment variables:

- on the background worker: `OFFLOADING_ENABLED` to `true` and `OFFLOADING_BUCKET_URL` to a valid URL of a storage bucket
- on the API server: `OFFLOADING_BUCKET_URL`

The `OFFLOADING_JOB_INTERVAL`, `OFFLOADING_BEFORE`, `OFFLOADING_BATCH_SIZE`, `OFFLOADING_SAVE_POINTS` and `OFFLOADING_WRITES_PER_SEC` may further be configured on the background worker, but the default values should work in most cases. See the Marble deployment guide on Github for more details on those variables. By default, Marble will offload data on decisions older than a week.

### Storage classes

The objects thus stored have a small size, even if they are cumbersome to store in a relational database. We strongly suggest that you write the objects to the "standard" object class, and do not use any lifecycle rules other than (optionally) deleting objects after a given time. Deleting the objects under `{bucket}/offloading/decision_rules` will not cause any errors in the application.

Specifically, moving objects to "archive" type storage classes is dangerous because the per-operation cost greatly exceeds the storage cost.

Objects are stored by decision status prefix (`offloading/decision_rules/{status}` where `status` is one of `error`, `hit`, `no_hit`), so it is possible in most blob storage solutions to configure different lifecycle rules for rules that did or did not result in a hit.
