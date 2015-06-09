require 'yaml'

require_relative 'dockyard/version'
require_relative 'dockyard/service_config'
require_relative 'dockyard/composer'
require_relative 'dockyard/script_runner'

module Dockyard
  DOCKYARD_CONFIGURATION_FILE = 'dockyard.yml'

  def self.load_config(base_path)
    file = File.join(base_path, DOCKYARD_CONFIGURATION_FILE)

    unless File.exists?(file)
      puts 'Missing dockyard.yml configuration file'
      exit 1
    end

    config = ::YAML.load_file(file)

    unless config
      puts 'Invalid dockyard.yml configuration file'
      exit 1
    end

    config
  end

  def self.service_names(base_path)
    load_config(base_path)['services']
  end
end
