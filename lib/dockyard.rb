require_relative "dockyard/version"
require_relative "dockyard/composer"

module Dockyard
  DOCKYARD_CONFIGURATION_FILE = 'dockyard.yml'

  def self.load_config
    unless File.exists?('dockyard.yml')
      puts "Missing dockyard.yml configuration file"
      exit 0
    end

    config = YAML.load_file(DOCKYARD_CONFIGURATION_FILE)

    unless config
      puts "Invalid dockyard.yml configuration file"
      exit 0
    end

    config
  end
end
