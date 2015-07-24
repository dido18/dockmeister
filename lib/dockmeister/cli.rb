module Dockmeister

  class Cli

    DOCKMEISTER_CONFIGURATION_FILE = 'dockmeister.yml'
    DOCKER_COMPOSE_FILENAME = 'docker-compose.yml'

    def initialize(base_path)
      @base_path = base_path
      @services = load_config['services']
    end

    def compose(*options)
      composed = Dockmeister::Composer.new(@base_path, @services).compose
      File.open(compose_file_path, 'w') { |f| f.write(composed.to_yaml) }
    end

    def build(*options)
      compose

      Dockmeister::ScriptRunner.new(@base_path, @services).pre_build!

      unless Kernel.system(command_with_options('build', options))
        puts 'Failed to build the Docker containers.'
        exit 1
      end

      Dockmeister::ScriptRunner.new(@base_path, @services).post_build!
    end

    def up(*options)
      Kernel.exec(command_with_options('up', options))
    end

    def compose_command
      "docker-compose --file #{compose_file_path}"
    end

    private

      def compose_file_path
        File.join(@base_path, DOCKER_COMPOSE_FILENAME)
      end

      def command_with_options(command, options)
        "#{compose_command} #{command} #{options.join(' ')}".strip
      end

      def load_config
        file = File.join(@base_path, DOCKMEISTER_CONFIGURATION_FILE)

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

  end

end
