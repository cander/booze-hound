# Docker Development Environment

This directory contains tools intended for doing development using Docker,
rather than running Rails natively on the developer's laptop. If this sounds
like [Devcontainers](https://containers.dev), it sorta is, and we intended to
support that in the future. For the moment, this is the bare minimum to
support a developer without Rails (probably on Windows with WSL).

We have our own Dockerfile here because this Docker image is not intended to
be run in production, which is what the Dockerfile in root is for. This
image will be built for development, and it will mount the application files
in a running container rather than building the application into the image.
This should allow for live-editing the application. And, of course, by
having a separate Dockerfile, there is the chance of drift between the
production and development Dockerfiles; we'll deal with that when/if it
becomes a problem.

## Usage

> _This section presumes that you're in `(working directory)/docker-dev`.
If you are calling these commands from the working directory's root, you'll
need to preface these commands with the path, such as
`./docker-dev/server-ctl.sh build` with the first command._

----

### Build

Build (or update) the Docker image of the app:

```bash
server-ctl.sh build
```

This has to be run if the `Gemfile.lock` file is updated, which happens
weekly via Dependabot.

### Load Database

> _This step will fail if the DB does not already exist; fix pending._

Load the development database with some initial data in `db/data.yml`, which
is not committed in git. (You'll have to obtain the `data.yml` file from a
project coordinator and then save it to the `db/` directory.)

```bash
server-ctl.sh loaddb
```

This is only really necessary initially or after (significant) database
migrations.

### Run the Application

Run the app:

```bash
server-ctl.sh run
```

Wait for console log messages to appear before trying to access the app.

## Future Work

* Maybe prune the Docker image to reduce its size. Use a multi-stage build
  to separate a bunch of the development tools from what's actually needed
  to deploy a development image.
