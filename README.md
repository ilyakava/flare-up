## Overview
```Flare-up``` provides a wrapper around the Redshift [```COPY```](http://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html) command for scriptability, allowing you to issue the command directly from the CLI.  Much of the code is concerned with simplifying constructing the COPY command and providing easy access to the errors that may result from import.

## Why?

Redshift prefers a bulk COPY operation over indidivuals INSERTs which "may be prohibitively slow" according to the documentation.  This means a tool like Sqoop is out, as the number of INSERTs would be prohibitvely large given the data sets many folks import into Redshift.  Additionally, COPY is a SQL command, not something issued via the AWS Redshift REST API, meaning you need a SQL connection to your Redshift instance to bulk load data.

The astute consumer of the AWS toolchain will note that [Data Pipeline](http://aws.amazon.com/datapipeline/) is one way this import may be completed however, we use Azkaban and the only thing worse than maintaining two job flow control systems is maintaining two job flow control systems :)

Additionally, access to COPY errors is a bit cumbersome.  Redshift populates the ```stl_load_errors``` table which inherently must be accessed via SQL.  Flare-up will pretty print any errors that occur during import so that you may examine your logs to versus having to establish a connection to Redshift to understand what went wrong.

## Sample Usage - Overview

At Sharethrough we're somewhat opinionated about having credentials present as environment variables for security purposes.  As such, please have the following environment variables set prior to executing flare-up:

```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export REDSHIFT_USERNAME=
export REDSHIFT_PASSWORD=
```
