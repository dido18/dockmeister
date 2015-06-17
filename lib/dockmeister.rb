require 'yaml'

require_relative 'dockmeister/version'
require_relative 'dockmeister/service_config'
require_relative 'dockmeister/composer'
require_relative 'dockmeister/script_runner'

module Dockmeister
  DOCKMEISTER_CONFIGURATION_FILE = 'dockmeister.yml'
  DOCKER_COMPOSE_CMD = 'docker-compose --file ./docker-compose.yml'

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

  def self.compose(*options)
    composed = Dockmeister::Composer.new('.').compose
    File.open('docker-compose.yml', 'w') { |f| f.write(composed.to_yaml) }
  end

  def self.build(*options)
    compose

    Dockmeister::ScriptRunner.new('.').pre_build!

    unless Kernel.system(command_with_options('build', options))
      puts 'Failed to build the Docker containers.'
      exit 1
    end

    Dockmeister::ScriptRunner.new('.').post_build!
  end

  def self.up(*options)
    Kernel.system(command_with_options('up', options))
  end

  private

  def self.command_with_options(command, options)
    "#{DOCKER_COMPOSE_CMD} #{command} #{options.join(' ')}"
  end
end
