# LivePomodoro Apps Devops

Thie repository provides all developer operations setup related to third party applications for the LivePomodoro environment. The idea is to centralize and develop an efficient and zero-effort (or almost zero) setup configuration for developers and devops engineers.

Changes to this repository should consider scaling up devops and environment configurations from local machines to remote machines. For example: we might want to run CI triggers from this repository to easily deploy a postgres, redis or any other application. Templates, charts, compose or whatever file we need for our deployment strategy should be versioned under the devops directory, probably with a subfolder describing the environment name (e.g.: `dev`).

## Requirements

> Note that this has been defined to use the latest versions but might work with not so old versions too. Take this versions as the upmost and desirable requirement.

* Docker: [`24.0.2`](https://docs.docker.com/desktop/install/ubuntu/)
* Compose plugin: [`v2.3.3`](https://docs.docker.com/compose/install/linux/)
* Tilt: [`0.32.4`](https://docs.tilt.dev/#macoslinux) (Optional)

## Getting started

### Local environmemt

Make a copy of the base env file

> At the moment there's no need to update any value, since we're not storing or using any valuable secert for local development environments.

```bash
cp .env.example .env
```

We use `make` to quickly run predefined tasks to setup, start and stop our environment.

```bash
# Type make to display the default help message.
# You'll notice a bunch of suggestions, skip them for now, they'll be useful as
# a reminder.
make
```

Now you can start all services:

```bash
make start
```

This will prompt a few options in your terminal, press T to navgate through services or Spacebar to open a friendly user interface. There you'll be able to get every app status and search for logs. If you did not install `tilt` then type `make devops.up`, it will start services with `docker compose`. You can then put them down with `make devops.down`.

If you want to stop all services just run:

```bash
make stop
```

That's all. The next time you need to start services just run:

```bash
make start
```

#### Postgres Admin

The local development environment uses a postgres database. We use the PGAdmin app to debug registries, create queries or just inspect information from the database.

See instructions at the [apps/pgadmin](./devops/apps/pgadmin/README.md) section.

### Dev Environment

> TODO

### Stage Environemnt

> TODO
