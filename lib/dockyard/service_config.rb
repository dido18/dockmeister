module Dockyard
  class ServiceConfig
    DOCKER_COMPOSE_FILENAME = 'docker-compose.yml'

    attr_reader :config

    def initialize(base_path, service)
      @base_path  = base_path
      @service    = service
      @config     = convert(load_file)
    end

    private

    def load_file
      YAML.load_file(File.join(@base_path, @service, DOCKER_COMPOSE_FILENAME))
    end

    def convert(config)
      config.values.each do |value|
        if value['build']
          value['build'] = service_path(@service, value['build'])
        end

        if value['volumes']
          value['volumes'] = value['volumes'].map do |volume|
            service_path(@service, volume)
          end
        end
      end

      config
    end

    def service_path(service, path)
      path.sub(/^.\//, "./#{service}/")
    end
  end
end
