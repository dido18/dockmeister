require 'spec_helper'

describe Dockyard::ScriptRunner do

  let(:script_runner) { Dockyard::ScriptRunner.new(base_path) }

  let(:base_path) { File.join('.', 'spec', 'fixtures') }

  describe '#pre_build!' do
    before :each do
      allow(Dockyard).to receive(:load_config) { services }
    end

    subject { script_runner.pre_build! }

    let(:services) do
      {
        'services' => [
          'foo',
          'bar'
        ]
      }
    end

    let(:pre_build_scripts) do
      {
        'foo' => [ 'pre' ],
        'bar' => [ 'pre-a.sh', 'pre-b.rb' ]
      }
    end

    it "runs all scripts starting with 'pre' ordered by filename" do
      pre_build_scripts.each do |service_name, script_names|
        script_names.each do |script_name|
          script_path = File.expand_path(File.join(base_path, service_name, "scripts", script_name))
          working_directory = File.expand_path(File.join(base_path, service_name))

          expect(script_runner).to receive(:run_script).once.ordered.with(script_path, working_directory)
        end
      end
      subject
    end
  end

  describe '#post_build!' do
    before :each do
      allow(Dockyard).to receive(:load_config) { services }
    end

    subject { script_runner.post_build! }

    let(:services) do
      {
        'services' => [
          'foo',
          'bar'
        ]
      }
    end

    let(:post_build_scripts) do
      {
        'foo' => [ 'post' ],
        'bar' => [ 'post-a.sh', 'post-b.rb' ]
      }
    end

    it "runs all scripts starting with 'post' ordered by filename" do
      post_build_scripts.each do |service_name, script_names|
        script_names.each do |script_name|
          script_path = File.expand_path(File.join(base_path, service_name, "scripts", script_name))
          working_directory = File.expand_path(File.join(base_path, service_name))

          expect(script_runner).to receive(:run_script).once.ordered.with(script_path, working_directory)
        end
      end
      subject
    end
  end

  describe '#run_script' do
    before :each do
      allow(STDERR).to receive(:puts)
    end

    subject { script_runner.run_script(File.join(base_path, service, script)) }

    context "for a successful script" do
      let(:service) { 'foo' }
      let(:script) { './scripts/post' }

      it "does not exit" do
        expect { subject }.to_not raise_error
      end
    end

    context "for a broken script" do
      let(:service) { 'broken_service' }
      let(:script) { './scripts/post' }

      it "exits" do
        expect { subject }.to raise_error(SystemExit)
      end
    end
  end

end
