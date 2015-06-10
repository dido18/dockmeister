module Dockyard
  class ScriptRunner
    def initialize(base_path)
      @base_path = base_path
    end

    def run_script(script)
      success = system(script)

      unless success
        STDERR.puts <<-eos

          A dockyard init script failed.
        eos
        exit(1)
      end
    end

    def pre_build!
      Dir.chdir(@base_path)

      Dockyard.load_config(@base_path)['services'].each do |service_name|
        Dir.glob(File.join('./', service_name, 'scripts', 'init*')).each do |script|
          run_script(script)
        end
      end
    end
  end
end
