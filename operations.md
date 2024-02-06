# Operations

_(Not much at the moment - more to come)_

## Daily update

```
bin/rake olcc:daily_update
```

## Data Transfer between Databases

Dump the data from the `from` environement to `db/data.yml`:
```
RAILS_ENV=from rake db:data:dump
```

Load the data into the `to` environement from `db/data.yml`:
```
RAILS_ENV=to rake db:data:load
```

## Run Rake Tasks in production

First run a web request to launch the machine. Then,
```
fly ssh console
root@148e470f751e89:/rails# bin/rake olcc:prettify_bottles
```

Note: the default, tiny, free memory configuration for the VM does not allow
running the Rails console when you ssh into the console. But, since it can
run Rake tasks, one-off commands can hacked into `lib/tasks` and then run
via Rake.  After a couple of commands, the console might go away when it
gets killed by the OOM killer. (Clearly, this will not scale.)

A simpler alternative is to scale the machine while performing the task.

```
fly scale memory 512
fly ssh console
do whatever
exit
fly scale memory 256
```


## Setup Daily Update from GitHub Actions
It's a bit of a Rube Goldberg machine, but we're using a
[cron workflow](.github/workflows/daily-update.yaml) in
GitHub Actions to trigger an endpoint to run the daily update over on Fly.
To secure it, we use a bearer token that we configure on both sides.

In GitHub, go to `Settings` -> `Secrets and Variables` -> `Actions` and set
the `TASKS_TOKEN` variable to the seclected value.

In the Fly console, go to `Secrets` and create a secret called `TASKS_TOKEN`
with the same value.

To disable the work of the task (e.g., during testing)
set the `DISABLE_TASKS` environment variable to any value.
For the deployed instance, add this in [`fly.toml`](fly.toml):
```
[env]
  DISABLE_TASKS = true
```

## Configuring Gmail as the SMTP Server
We're (currently) using Gmail as the SMTP server. To configure this in
production, there are two environment variables/secrets that need to be set
in Fly:

* `GMAIL_USER` - the email address of a Gmail user. Emails will come from
  that user. This isn't super-sensitive (unlike a password or API key), but
  it could/should be configured as a secret in Fly anyway.
* `GMAIL_APP_PW` - the Gmail app password that is required if you have 2FA on
  your Gmail account. It should be 4 groups of 4 letters like: 
  `abcd abcd abcd abcd`. Since this is a password, it should be stored
  as a secret in Fly.

## Production Logging
Logs go to Loggly or standard out. Using Loggly requires an API token stored
in a secret called `LOGGLY_API_TOKEN`.  If the token is missing, Loggly is
quietly not configured and standard out is used instead. Fly will capture
standard out to their Monitoring page.
