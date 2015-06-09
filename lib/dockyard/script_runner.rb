module Dockyard
  class ScriptRunner
    def initialize(base_path)
      @base_path = base_path
    end

    def run_script(script)
      success = system(script)

      unless success
        STDERR.puts ""
        STDERR.puts "A dockyard init script failed."
        exit(1)
      end
    end

    def pre_compose!
      Dir.chdir(@base_path)
      base_dir = Dir.pwd

      Dockyard.load_config(@base_path)['services'].each do |service_name|
        Dir.chdir(service_name)

        Dir.glob('./scripts/init*').each do |script|
          success = run_script(script)
        end

        Dir.chdir(base_dir)
      end
    end
  end
end
