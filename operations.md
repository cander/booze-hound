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
