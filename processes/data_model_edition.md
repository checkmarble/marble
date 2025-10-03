# Data model edition
You can add as many fields, tables, or relations as needed directly from Marble. However, to delete any of these elements, you’ll need to make the changes directly in your Marble PostgreSQL database.

BE AWARE : removing fields or objects used in existing scenarios may generate errors and crashes. Do not remove fields and objects use in a scenario without also deleting the scenario. 

## Delete a table
**1. Find the table**
Get your table id with:
```
select *`
from data_model_tables as t
where t.name = 'your_table_name'
```
**2. Check that the table is not used in any links**
```
select *
from data_model_links
where parent_table_id='table_id' or child_table_id='table_id'
```
If any links are found, **delete the link**:
`delete from data_model_links where id='link_id'`

**3. Delete the table from your data model**
`delete from data_model_tables where id='table_id'`

**4. Delete the actual table**
Find your table in `org-{orgName}.{yourTableName}`
Then drop it: 
`drop table org-{orgName}.{yourTableName}`

## Delete a field
**1. Find the field**
Get your field id with:
```
select *
from data_model_tables as t
inner join data_model_fields as f on (f.table_id=t.id)
where t.name = 'your_table_name'
```
**2. Check that the table is not used in any links**
```
select *
from data_model_links
where parent_field_id='field_id' or child_field_id='field_id'
```
If any links are found, **delete the link**:
`delete from data_model_links where id='link_id'`

**3. Delete the field from your data model**
`delete from data_model_fields where id='field_id'`

**4. Delete the actual field in the table**
Find your table in `org-{orgName}.{yourTableName}`
Then drop the field:  
`alter table org-{orgName}.{yourTableName} drop
column {yourFieldName}`
