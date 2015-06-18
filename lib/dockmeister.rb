require 'yaml'

require_relative 'dockmeister/version'
require_relative 'dockmeister/service_config'
require_relative 'dockmeister/composer'
require_relative 'dockmeister/script_runner'

module Dockmeister
  DOCKMEISTER_CONFIGURATION_FILE = 'dockmeister.yml'
  DOCKER_COMPOSE_FILENAME = 'docker-compose.yml'

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
    composed = Dockmeister::Composer.new(base_path).compose
    File.open(compose_file_path, 'w') { |f| f.write(composed.to_yaml) }
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
    Kernel.exec(command_with_options('up', options))
  end

  def self.base_path
    '.'
  end

  def self.compose_command
    "docker-compose --file #{compose_file_path}"
  end

  private

  def self.compose_file_path
    File.join(base_path, DOCKER_COMPOSE_FILENAME)
  end

  def self.command_with_options(command, options)
    "#{compose_command} #{command} #{options.join(' ')}".strip
  end
end
