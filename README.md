# Dockyard

Orchestrates several Docker-based applications into one.

Each service has its own `docker-compose.yml`, in order to bootstrap the required databases, filesystems, app servers, etc. However, a lot of times, you actually want to run a whole set of services, instead of just one. This is where Dockyard comes in.

## Usage
Create a `dockyard.yml` file anywhere you wish in your filesystem. This file will contain paths to the several services you wish to bootstrap:

```yaml
foo: "~/Code/foo"
bar: "/some/other/path/bar"
baz: "/baz"
```

The paths should point to the root of your service, where the individual `docker-compose.yml` files are present.

Now, when you run `dockyard` in the directory where the `dockyard.yml` file lives, it will string together all of the apps' `docker-compose.yml` files into a single `docker-compose.yml` file, adjusting all of the `build` and `volume` paths to be relative to this directory. You can then start your services all at once like you'd normally do:

```bash
docker-compose up
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dockyard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
