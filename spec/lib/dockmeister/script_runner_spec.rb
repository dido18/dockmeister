require 'spec_helper'

describe Dockmeister::ScriptRunner do

  let(:script_runner) { Dockmeister::ScriptRunner.new(base_path, services) }
  let(:base_path)     { File.join('.', 'spec', 'fixtures') }
  let(:services)      { ['foo', 'bar'] }

  describe '#pre_build!' do

    subject { script_runner.pre_build! }

    let(:pre_build_scripts) do
      {
        'foo' => [ 'pre' ],
        'bar' => [ 'pre-a.sh', 'pre-b.rb' ]
      }
    end

    it 'runs all scripts starting with "pre" ordered by filename' do
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

    subject { script_runner.post_build! }

    let(:post_build_scripts) do
      {
        'foo' => [ 'post' ],
        'bar' => [ 'post-a.sh', 'post-b.rb' ]
      }
    end

    it 'runs all scripts starting with "post" ordered by filename' do
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

    subject { script_runner.run_script(File.join(base_path, service, script)) }

    before :each do
      allow(STDERR).to receive(:puts)
    end

    context 'for a successful script' do

      let(:service) { 'foo' }
      let(:script) { './scripts/post' }

      it 'does not exit' do
        expect { subject }.to_not raise_error
      end

    end

    context 'for a broken script' do

      let(:service) { 'broken_service' }
      let(:script) { './scripts/post' }

      it "exits" do
        expect { subject }.to raise_error(SystemExit)
      end

    end

    context 'environment variables' do

      let(:service) { 'foo' }
      let(:script) { './scripts/post' }
      let(:env_vars) do
        {
          'DOCKMEISTER_COMPOSE_FILE' => 'docker-compose.yml'
        }
      end

      before :each do
        allow(script_runner).to receive(:script_env_vars) { env_vars }
      end

      it "populates the DOCKER_COMPOSE_FILE env var" do
        expect(Kernel).to receive(:system).with(env_vars, anything, anything) { true }
        subject
      end

    end

  end

end
