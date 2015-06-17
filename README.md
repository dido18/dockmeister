# Dockmeister

Orchestrates several `docker-compose`-based services into one.

Dockmeister will facilitate the integration of several `docker-compose`-based services by concatenating their `docker-compose.yml` configurations into one.

In addition, Dockmeister allows you to specify scripts that are executed before or after building a particular service, which can be used for steps such as seeding a database.

## Usage

Create a `dockmeister.yml` file at the root level of where your services reside. This file will contain the names of all the services you wish to bootstrap:

```yaml
services:
  - foo
  - bar
  - baz
```

A service is defined by a directory that contains a `docker-compose.yml` specifying its dependencies. Pre- and post-build scripts reside in the `scripts/` sub-directory.

```
  foo/
    docker-compose.yml
    appserver/
      Dockerfile
    database/
      Dockerfile
    filesystem/
      Dockerfile
    scripts/
      pre_do_something.sh
      post_seed_the_database.rb
```

### Dockmeister commands

```bash
dockmeister [COMMAND]
```

#### compose

Prepares a composition of each services' `docker-compose.yml` file into a single `docker-compose.yml` file. All `build` and `volume` paths are adjusted to be relative to the root directory.

#### build

- Runs the pre-build scripts for each service
- Builds all docker containers using `docker-compose build`.
- Runs the post-build scripts for each service

Pre- and post-build scripts reside in the `scripts/` sub-directory.
The filenames of the scripts are required to have a `pre` or `post` prefix.
The scripts will be run from the service folder.

#### up

Starts the containers using `docker-compose up`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/dockmeister/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
