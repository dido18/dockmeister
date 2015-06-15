module Dockmeister
  class ScriptRunner
    DOCKMEISTER_COMPOSE_FILE = 'docker-compose.yml'

    def initialize(base_path)
      @base_path = File.expand_path(base_path)
    end

    def run_script(script, working_directory = ".")
      success = Kernel.system(script_env_vars, script, chdir: working_directory)

      unless success
        STDERR.puts <<-eos

          A dockmeister init script failed.
        eos
        exit(1)
      end
    end

    def pre_build!
      run_with_prefix('pre')
    end

    def post_build!
      run_with_prefix('post')
    end

    def script_env_vars
      {
        'DOCKMEISTER_COMPOSE_FILE' => dockmeister_compose_file_path
      }
    end

    private

    def run_with_prefix(prefix)
      pattern = "#{prefix}*"

      Dockmeister.load_config(@base_path)['services'].each do |service_name|
        service_directory = File.join(@base_path, service_name)
        Dir.glob(File.join(service_directory, 'scripts', pattern)).each do |script|
          run_script(File.expand_path(script), service_directory)
        end
      end
    end

    def dockmeister_compose_file_path
      File.join(@base_path, DOCKMEISTER_COMPOSE_FILE)
    end
  end
end
