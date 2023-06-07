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

## Run rake Tasks on production

First run a web request to launch the machine. Then,
```
fly ssh console
root@148e470f751e89:/rails# bin/rake olcc:prettify_bottles
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
For the deployed instance, do this in `[fly.toml](fly.toml)`:
```
[env]
  DISABLE_TASKS = true
```
