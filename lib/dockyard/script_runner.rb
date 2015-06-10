module Dockyard
  class ScriptRunner
    def initialize(base_path)
      @base_path = File.expand_path(base_path)
    end

    def run_script(script, working_directory = ".")
      success = system(script, chdir: working_directory)

      unless success
        STDERR.puts <<-eos

          A dockyard init script failed.
        eos
        exit(1)
      end
    end

    def pre_build!
      Dockyard.load_config(@base_path)['services'].each do |service_name|
        service_directory = File.join(@base_path, service_name)
        Dir.glob(File.join(service_directory, 'scripts', 'init*')).each do |script|
          run_script(File.expand_path(script), service_directory)
        end
      end
    end
  end
end
