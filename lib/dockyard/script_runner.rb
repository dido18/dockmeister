module Dockyard
  class ScriptRunner
    def initialize(base_path)
      @base_path = base_path
    end

    def run_script(script)
      system(script)
    end

    def pre_compose!
      Dir.chdir(@base_path)
      
      Dockyard.load_config(@base_path)['services'].each do |service_name|
        Dir.chdir(service_name)

        Dir.glob('./scripts/init*').each do |script|
          success = run_script(script)
          break unless success
        end

        Dir.chdir(@base_path)
      end
    end
  end
end
