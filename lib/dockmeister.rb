require 'yaml'

require_relative 'dockmeister/version'
require_relative 'dockmeister/service_config'
require_relative 'dockmeister/composer'
require_relative 'dockmeister/script_runner'

module Dockmeister
  DOCKMEISTER_CONFIGURATION_FILE = 'dockmeister.yml'

  def self.load_config(base_path)
    file = File.join(base_path, DOCKMEISTER_CONFIGURATION_FILE)

    unless File.exists?(file)
      puts 'Missing dockmeister.yml configuration file'
      exit 1
    end

    config = ::YAML.load_file(file)

    unless config
      puts 'Invalid dockmeister.yml configuration file'
      exit 1
    end

    config
  end

  def self.compose
    composed = Dockmeister::Composer.new('.').compose

    File.open('docker-compose.yml', 'w') { |f| f.write(composed.to_yaml) }
  end

  def self.build
    compose

    Dockmeister::ScriptRunner.new('.').pre_build!

    unless Kernel.system("#{DOCKER_COMPOSE_CMD} build")
      puts 'Failed to build the Docker containers.'
      exit 1
    end

    Dockmeister::ScriptRunner.new('.').post_build!
  end

  def self.up
    Kernel.system("#{DOCKER_COMPOSE_CMD} up")
  end
end
