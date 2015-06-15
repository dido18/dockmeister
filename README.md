# Dockmeister

Orchestrates several Docker-based applications into one.

Each service has its own `docker-compose.yml`, in order to bootstrap the required databases, filesystems, app servers, etc. However, a lot of times, you actually want to run a whole set of services, instead of just one. This is where Dockmeister comes in.

## Usage

Create a `dockmeister.yml` file at the root level of where your services reside. This file will contain the names of all the services you wish to bootstrap:

```yaml
services:
  - foo
  - bar
  - baz
```

Each service is defined in a sub-directory with the same name that contains a `docker-compose.yml` and optional pre- and post-build scripts in `scripts/`.

### Dockmeister commands

```bash
dockmeister [COMMAND]
```

#### compose

Prepares a composition of each configured services' "docker-compose.yml" file into a single `docker-compose.yml` file, adjusting all of the `build` and `volume` paths to be relative to the current directory.

#### build

Runs pre-build scripts for every service and builds the docker containers using "docker-compose build".
Pre-build scripts are all scripts starting with "init" in a services' `scripts` directory.
The scripts will be run from the service folder.

#### up

Starts the containers using "docker-compose up"


## Contributing

1. Fork it ( https://github.com/[my-github-username]/dockmeister/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
