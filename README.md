## Overview
```Flare-up``` provides a wrapper around the Redshift [```COPY```](http://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html) command for scriptability, allowing you to issue the command directly from the CLI.  Much of the code is concerned with simplifying constructing the COPY command and providing easy access to the errors that may result from import.

## Why?

Redshift prefers a bulk COPY operation over indidivual INSERTs which Redshift is not optimized for, and Amazon does not recommend it as a strategy for bulk loading.  This means a tool like Sqoop is out, as the number of INSERTs would be prohibitvely large given the data sets many folks import into Redshift.  Additionally, COPY is a SQL command, not something issued via the AWS Redshift REST API, meaning you need a SQL connection to your Redshift instance to bulk load data.

The astute consumer of the AWS toolchain will note that [Data Pipeline](http://aws.amazon.com/datapipeline/) is one way this import may be completed however, we use Azkaban and the only thing worse one than one job flow control tool is two job flow control tools :)

Additionally, access to COPY errors is a bit cumbersome.  On failure, Redshift populates the ```stl_load_errors``` table which inherently must be accessed via SQL.  Flare-up will pretty print any errors that occur during import so that you may examine your logs to versus having to establish a connection to Redshift to understand what went wrong.

```
TODO PASTE EXAMPLE OF PRETTY PRINT ERROR HERE
```

## Sample Usage - Overview

At Sharethrough we're somewhat opinionated about having credentials present as environment variables for security purposes, and recommend it as a productionalized approach.  That being said, it can be a pain to export variables when you're testing a tool and as such, we support specifying all of these on the command-line.

### Environment Variables

These will be queried if no command-line options are specified.

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export REDSHIFT_USERNAME=
export REDSHIFT_PASSWORD=
```
