require 'spec_helper'

describe Dockyard::ScriptRunner do

  let(:script_runner) { Dockyard::ScriptRunner.new(base_path) }

  let(:base_path) { './spec/fixtures' }

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

    it "runs all scripts starting with 'init'" do
      expect(script_runner).to receive(:run_script).exactly(3).times { true }
      subject
    end
  end

  describe '#run_script' do
    before :each do
      allow(STDERR).to receive(:puts)
    end

    subject { script_runner.run_script(script) }

    context "for a successful script" do
      let(:script) { './foo/scripts/init' }

      it "does not exit" do
        expect { subject }.to_not raise_error
      end
    end

    context "for a broken script" do
      let(:script) { './broken_service/scripts/init' }

      it "exits" do
        expect { subject }.to raise_error(SystemExit)
      end
    end
  end

end
