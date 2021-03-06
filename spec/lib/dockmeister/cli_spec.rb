require "spec_helper"

describe Dockmeister::Cli do

  let(:base_path) { File.join(".", "spec", "fixtures") }
  let(:cli) { Dockmeister::Cli.new(base_path) }

  before :each do
    allow_any_instance_of(Dockmeister::Cli).to receive(:load_config) { { services: [] } }
  end

  describe "#compose" do

    subject { cli.compose(nil) }

    let(:file_path)       { File.join(base_path, "docker-compose.yml") }
    let(:composer_double) { double("Dockmeister::Composer") }
    let(:composition)     { { foo: "bar" } }

    before :each do
      allow(Dockmeister::Composer).to receive(:new) { composer_double }
      allow(composer_double).to receive(:compose) { composition }
    end

    after :each do
      File.delete(file_path)
    end

    it 'writes a "docker-compose.yml" file with the yaml version of the return from Dockmeister::Composer#compose' do
      subject
      expect(YAML.load_file(file_path)).to eq(composition)
    end

  end

  describe "#build" do

    subject { cli.build(options) }

    let(:script_runner) { double("Dockmeister::ScriptRunner") }
    let(:options) { [] }

    before :each do
      allow(Dockmeister::ScriptRunner).to receive(:new) { script_runner }
      allow(script_runner).to receive(:pre_build!)
      allow(script_runner).to receive(:post_build!)
      allow(cli).to receive(:compose)
      allow(cli).to receive(:load_config) { { services: [] } }
      allow(Kernel).to receive(:system) { true }
    end

    it "runs #compose" do
      expect(cli).to receive(:compose)
      subject
    end

    context "when options are passed" do

      let(:options) { ["--no-cache", "--some-other-flag"] }

      it 'runs "docker-compose build" with options' do
        command = "#{cli.compose_command} build #{options.join(" ")}"
        expect(Kernel).to receive(:system).with(command) { true }
        subject
      end

    end

    context "when options are nil" do

      let(:options) { nil }

      it 'runs "docker-compose build"' do
        command = "#{cli.compose_command} build"
        expect(Kernel).to receive(:system).with(command) { true }
        subject
      end

    end

  end

  describe "#up" do

    subject { cli.up(options) }

    before :each do
      allow(Kernel).to receive(:exec) { true }
    end

    context "when options are passed" do

      let(:options) { ["--no-cache", "--some-other-flag"] }

      it 'runs "docker-compose up" with options' do
        command = "#{cli.compose_command} up #{options.join(" ")}"
        expect(Kernel).to receive(:exec).with(command) { true }
        subject
      end

    end

    context "when options are nil" do

      let(:options) { nil }

      it 'runs "docker-compose up"' do
        command = "#{cli.compose_command} up"
        expect(Kernel).to receive(:exec).with(command) { true }
        subject
      end

    end

  end

  describe "#compose_command" do

    subject { cli.compose_command }

    let(:compose_file_path) { File.join(base_path, Dockmeister::Cli::DOCKER_COMPOSE_FILENAME) }
    let(:command) { "docker-compose --file #{compose_file_path}" }

    it { is_expected.to eq(command) }

  end

end
