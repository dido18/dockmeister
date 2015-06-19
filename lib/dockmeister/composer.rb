module Dockmeister
  class Composer
    def initialize(base_path, services)
      @service_configs = services.map { |service| ServiceConfig.new(base_path, service).config }
    end

    def compose
      @service_configs.inject({}) { |memo, config| memo.merge!(config) }
    end
  end
end
