require 'spec_helper'

describe Dockyard::ScriptRunner do

  describe '#pre_compose!' do
    subject { Dockyard::ScriptRunner.new(base_path).pre_compose! }

    let(:base_path) { './spec/fixtures' }
    let(:services) do
      {
        'services' => [
          'foo',
          'bar',
          'baz'
        ]
      }
    end
    let(:script_runner) { instance_double('Dockyard::ScriptRunner') }

    before :each do
      allow(Dockyard).to receive(:load_config)        { services }
    end

    it "runs all scripts matching a 'init*' glob" do
      expect(subject).to have_received(:run_script).exactly(3).times
    end
  end

end
