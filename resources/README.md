## Resources
Used to facilitate development of ```flare-up```, these are not packaged as part of the gem, nor do they constitute a public API.  Consume at your own risk :)

- ```hearthstone_cards.csv```: Small list of Hearthstone cards to COPY.
- ```load_hearthstone_cards.rb```: Utilize the internal API to COPY from a single S3 file into a test Redshift database.  Note that the internal design is subject to, and will definitely change.
- ```postgresql-8.4-703.jdbc4.jar```: Used by [SQLWorkbenchJ](http://www.sql-workbench.net/index.html) to connect to Redshift.  The current version of the official Postgres client does not support connecting to Redshift because it is such an old version (supports >= 8.4, Redshift is 8.0).
- ```test_schema.sql```: Prepare our test Redshift database for ingestion.