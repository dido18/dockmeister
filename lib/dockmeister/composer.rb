module Dockmeister
  class Composer
    def initialize(base_path)
      @base_path = base_path
    end

    def compose
      services_with_dependencies.inject({}) { |memo, config| memo.merge!(config) }
    end

    private

    def service_names
      Dockmeister.load_config(@base_path)['services']
    end

    def services_with_dependencies
      service_configs + dependency_configs
    end

    def service_configs
      @service_configs ||= service_names.map(&method(:service_config_from_service))
    end

    def dependency_configs
      @dependencies ||= service_configs.lazy.flat_map do |config|
        config.values
          .flat_map(&method(:dependencies_in_config))
          .map(&method(:service_config_from_service))
      end.to_a
    end

    def dependencies_in_config(config)
      [config['links'], config['external_links'], config['volumes_from']]
        .compact
        .flatten
    end

    def service_config_from_service(service)
      ServiceConfig.new(@base_path, service).config
    end
  end
end
