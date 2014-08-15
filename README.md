## Overview
```Flare-up``` provides a wrapper around the Redshift [```COPY```](http://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html) command for scriptability, allowing you to issue the command directly from the CLI.  Much of the code is concerned with simplifying constructing the COPY command and providing easy access to the errors that may result from import.

## Why?

Redshift prefers a bulk COPY operation over indidivual INSERTs which Redshift is not optimized for, and Amazon does not recommend it as a strategy for loading.  COPY is a SQL command, not something issued via the AWS Redshift REST API, meaning you need a SQL connection to your Redshift instance to bulk load data.

The astute consumer of the AWS toolchain will note that [Data Pipeline](http://aws.amazon.com/datapipeline/) is one way this import may be completed however, we use Azkaban and the only thing worse one than one job flow control tool is two job flow control tools :)

Additionally, access to COPY errors is a bit cumbersome.  On failure, Redshift populates the ```stl_load_errors``` table which inherently must be accessed via SQL.  Flare-up will pretty print any errors that occur during import so that you may examine your logs rather than establishing a connection to Redshift to understand what went wrong.

## Requirements and Installation

The `pg` gem is a dependency (required to issue SQL commands to Redshift) and will be pulled down with flare-up.

```
> gem install flare-up
```

## Syntax

Available via `flare-up help copy`.

While we'd prefer if everyone stored configuration variables (esp. credentials) as environment variables (re: [Twelve-Factor App](http://12factor.net/)), it can be a pain to export variables when you're testing a tool and as such, we support specifying all of these on the command-line.

```
Usage:
  flare-up copy DATA_SOURCE REDSHIFT_ENDPOINT DATABASE TABLE

Options:
  [--aws-access-key=AWS_ACCESS_KEY]            # Required unless ENV['AWS_ACCESS_KEY_ID'] is set.
  [--aws-secret-key=AWS_SECRET_KEY]            # Required unless ENV['AWS_SECRET_ACCESS_KEY'] is set.
  [--redshift-username=REDSHIFT_USERNAME]      # Required unless ENV['REDSHIFT_USERNAME'] is set.
  [--redshift-password=REDSHIFT_PASSWORD]      # Required unless ENV['REDSHIFT_PASSWORD'] is set.
  [--column-list=one two three]                # A space-separated list of columns, should your DATA_SOURCE require it
  [--copy-options=COPY_OPTIONS]                # Appended to the end of the COPY command; enclose "IN QUOTES"
  [--colorize-output], [--no-colorize-output]  # Should Flare-up colorize its output?
                                               # Default: true
```

## Sample Usage

Note that this example assumes you have credentials set as environment variables.

```
> flare-up                                                      \
    copy                                                        \
    s3://slif-redshift/hearthstone_cards_short_list.csv         \
    flare-up-test.cskjnp4xvaje.us-west-2.redshift.amazonaws.com \
    dev                                                         \
    hearthstone_cards                                           \
    --column-list name cost attack health description           \
    --copy-options "REGION 'us-east-1' CSV"
```
