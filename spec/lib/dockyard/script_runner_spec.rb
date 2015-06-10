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

    it "runs all scripts starting with 'init' ordered by filename" do
      expect(script_runner).to receive(:run_script).once.ordered.with("./scripts/init")
      expect(script_runner).to receive(:run_script).once.ordered.with("./scripts/init-a.sh")
      expect(script_runner).to receive(:run_script).once.ordered.with("./scripts/init-b.rb")
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
      let(:script) { './scripts/init' }

      it "does not exit" do
        expect { subject }.to_not raise_error
      end
    end

    context "for a broken script" do
      let(:service) { 'broken_service' }
      let(:script) { './scripts/init' }

      it "exits" do
        expect { subject }.to raise_error(SystemExit)
      end
    end
  end

end
