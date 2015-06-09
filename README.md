# Dockyard

Orchestrates several Docker-based applications into one.

Each service has its own `docker-compose.yml`, in order to bootstrap the required databases, filesystems, app servers, etc. However, a lot of times, you actually want to run a whole set of services, instead of just one. This is where Dockyard comes in.

## Usage
Create a `dockyard.yml` file at the root level of where your services reside. This file will contain the names of the several services you wish to bootstrap:

```yaml
services:
  - foo
  - bar
  - baz
```

Now, when you run `dockyard compose`, it will string together all of the services' `docker-compose.yml` files into a single `docker-compose.yml` file, adjusting all of the `build` and `volume` paths to be relative to the current directory. You can then start your services all at once like you'd normally do:

```bash
dockyard build
dockyard up
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dockyard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
