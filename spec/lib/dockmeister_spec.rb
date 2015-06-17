require 'spec_helper'

describe Dockmeister do

  describe '.build' do

    subject { Dockmeister.build(options) }

    let(:options)       { ['--no-cache', '--some-other-flag'] }
    let(:script_runner) { double('Dockmeister::ScriptRunner') }

    before :each do
      allow(Dockmeister::ScriptRunner).to receive(:new) { script_runner }
      allow(script_runner).to receive(:pre_build!)
      allow(script_runner).to receive(:post_build!)
      allow(Dockmeister).to receive(:compose)
      allow(Kernel).to receive(:system) { true }
    end

    it 'runs .compose' do
      expect(Dockmeister).to receive(:compose)

      subject
    end

    it 'runs "docker-compose build" with options' do
      command = "#{Dockmeister::DOCKER_COMPOSE_CMD} build #{options.join(' ')}"
      expect(Kernel).to receive(:system).with(command) { true }

      subject
    end

  end

  describe '.up' do

    subject { Dockmeister.up(options) }

    let(:options)       { ['--no-cache', '--some-other-flag'] }

    it 'runs "docker-compose up" with options' do
      command = "#{Dockmeister::DOCKER_COMPOSE_CMD} up #{options.join(' ')}"
      expect(Kernel).to receive(:system).with(command) { true }

      subject
    end

  end

end
