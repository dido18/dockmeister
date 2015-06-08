module Dockyard
  class Composer

    def self.compose(services)
      services.inject({}) do |memo, (service, config)|
        config.values.each do |value|
          if value['build']
            value['build'] = service_path(service, value['build'])
          end

          if value['volumes']
            value['volumes'] = value['volumes'].map do |volume|
              service_path(service, volume)
            end
          end
        end

        memo.merge!(config)
      end
    end

    private

    def self.service_path(service, path)
      path.sub(/^.\//, "./#{service}/")
    end

  end
end
