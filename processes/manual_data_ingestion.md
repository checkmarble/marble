# Manually ingest your data using a storage bucket


This guide outlines the procedure for manually uploading data by directly
placing a CSV file into a storage bucket and creating a corresponding log entry
to trigger the ingestion process.

## 1. Prepare and validate your CSV file

Before initiating the manual upload, it is crucial to ensure your data is correctly
formatted.

- **Create the CSV File:** Compile the data you need to ingest into a standard
CSV file.
- **Verify the format:** The structure of your CSV file (columns, headers, data
types) must exactly match the requirements of the target table in
checkmarble.com.
- **Recommendation:** To confirm the format, it is highly recommended to first
perform a standard upload using a small sample of your data (a few rows)
through the normal user interface. This will help you catch any formatting
errors before proceeding with the manual process, which may bypass some
validation checks.

## 2. Upload the file to the storage bucket

Once your CSV file is ready, you need to upload it to the designated cloud
storage bucket.

- **Access the bucket:** Connect to your organization's cloud storage (e.g.,
Amazon S3, Google Cloud Storage).
- **Define the file path:** The name and location of the file must follow a strict
naming convention. The path should be: `{org_id}/{table_name}/{unix_timestamp}.csv`
	- `{org_id}`: Your organization's unique identifier.
	- `{table_name}`: The name of the destination table for the data.
	- `{unix_timestamp}`: The current time in Unix timestamp format (the number of
seconds since January 1, 1970).
- **Upload the file:** Place your CSV file in the specified path within the bucket.

## 3. Create a record in `upload_logs`

Next, you must manually insert a new record into the `upload_logs` database table.
This entry tells the system to process your uploaded file.

- **Execute an SQL INSERT statement:** Run the following SQL command,
replacing the bracketed placeholders with the correct values:
```sql
INSERT INTO upload_logs (org_id, user_id, file_name, status, table_name)
VALUES ({org_id}, {user_id},'{file_name}','pending','{table_name}');
```
- **How to find the values:**
	- `{org_id}`: Your organization's ID.
	- `{user_id}`: The ID of the user performing the upload. You can find this by
running: `SELECT user_id, email FROM users;`
	- `{file_name}`: The full path of the file you uploaded, exactly as it appears in
the storage bucket (e.g., `123/customers/1662631200.csv`).
	- `{table_name}`: The name of the target table.

## 4. Monitor the ingestion process

Finally, you need to verify that the ingestion starts and completes successfully.

- **Check for initiation:** Wait approximately one minute after creating the log
entry. Check the status of the upload in the `upload_logs` table or the
Checkmarble.com interface to ensure the process has started. The status
should change from `pending` to a state like `processing` or `running`.
- **Confirm completion:** Allow several minutes for the ingestion to finish. The
time required will depend on the size of your file.
- **Verify the outcome:** Once enough time has passed, check the log again to
confirm that the status has changed to `completed` or `success`. You should also
verify that the data appears correctly in the destination table within
checkmarble.com.
