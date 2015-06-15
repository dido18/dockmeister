require 'spec_helper'

describe Dockmeister::Composer do

  describe '#compose' do
    subject { Dockmeister::Composer.new(base_path).compose }

    let(:base_path) { '.' }

    let(:foo_configuration) do
      {
        'fooservice' => {
          'build' => './service/',
          'ports' => [
            '8080'
          ],
          'links' => [
            'depservice'
          ],
          'external_links' => [
            'extdepservice'
          ],
          'volumes' => [
            './service/foo:/root/worker'
          ]
        },
        'fooredis' => {
          'build' => './redis/',
          'ports' => [
            '6379:6379'
          ],
          'volumes_from' => [
            'volumesfromdepservice'
          ]
        }
      }
    end

    let(:bar_configuration) do
      {
        'barservice' => {
          'build' => './service/',
          'links' => [
            'depservice'
          ],
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

    let(:dependency_configuration) do
      {
        'depservice' => {
          'image' => 'dep'
        }
      }
    end

    let(:external_dependency_configuration) do
      {
        'extdepservice' => {
          'image' => 'dep'
        }
      }
    end

    let(:volumes_from_dependency_configuration) do
      {
        'volumesfromdepservice' => {
          'image' => 'dep'
        }
      }
    end

    let(:services) do
      {
        'services' => [
          'foo',
          'bar'
        ]
      }
    end

    before :each do
      allow(Dockmeister).to receive(:load_config) { services }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'foo') { double('Dockmeister::ServiceConfig', config: foo_configuration) }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'bar') { double('Dockmeister::ServiceConfig', config: bar_configuration) }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'depservice') { double('Dockyard::ServiceConfig', config: dependency_configuration) }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'extdepservice') { double('Dockyard::ServiceConfig', config: external_dependency_configuration) }
      allow(Dockmeister::ServiceConfig).to receive(:new).with(base_path, 'volumesfromdepservice') { double('Dockyard::ServiceConfig', config: volumes_from_dependency_configuration) }
    end

    it 'concatenates services\' compose configurations' do
      expect(subject.keys).to include('fooservice', 'fooredis', 'barservice', 'barredis')
    end

    it 'inserts dependencies stated in the "links" array' do
      expect(subject.keys).to include('depservice')
    end

    it 'inserts dependencies stated in the "external_links" array' do
      expect(subject.keys).to include('extdepservice')
    end

    it 'inserts dependencies stated in the "volumes_from" array' do
      expect(subject.keys).to include('volumesfromdepservice')
    end

    it 'guarantees unique service configurations' do
      depservices = subject.keys.select { |service| service == 'depservice' }
      expect(depservices.count).to eq(1)
    end

  end

end
