require 'spec_helper'

describe Dockmeister::Composer do

  describe '#compose' do
    subject { Dockmeister::Composer.new(base_path, services).compose }

    let(:base_path) { '.' }

    let(:foo_configuration) do
      {
        'fooservice' => {
          'build' => './service/',
          'ports' => [
            '8080'
          ],
          'volumes' => [
            './service/foo:/root/worker'
          ]
        },
        'fooredis' => {
          'build' => './redis/',
          'ports' => [
            '6379:6379'
          ]
        }
      }
    end

    let(:bar_configuration) do
      {
        'barservice' => {
          'build' => './service/',
          'ports' => [
            '8080'
          ],
          'volumes' => [
            './service/bar:/root/worker'
          ]
        },
        'barredis' => {
          'image' => 'redis',
          'ports' => [
            '6379:6379'
          ]
        }
      }
    end

    let(:services) do
      [
        'foo',
        'bar'
      ]
    end

    before :each do
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'foo') { double('Dockmeister::ServiceConfig', config: foo_configuration) }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'bar') { double('Dockmeister::ServiceConfig', config: bar_configuration) }
    end

    it 'concatenates services\' compose configurations' do
      expect(subject.keys).to eq(foo_configuration.keys + bar_configuration.keys)
    end

  end

end
