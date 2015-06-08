require 'spec_helper'

describe Dockyard::ServiceConfig do
  describe '#config' do
    subject { Dockyard::ServiceConfig.new(base_path, service).config }

    let(:base_path) { '.' }
    let(:service)   { 'foo' }
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

    before :each do
      allow(YAML).to receive(:load_file).with("#{base_path}/#{service}/docker-compose.yml") { foo_configuration }
    end

    it 'replaces path references for "build" keys' do
      build_values = subject.map { |service, config| config['build'] }.compact

      expect(build_values).to eq(['./foo/service/', './foo/redis/'])
    end

    it 'replaces path references for "volumes" keys' do
      volumes_values = subject.map { |service, config| config['volumes'] }.compact

      expect(volumes_values).to eq([['./foo/service/foo:/root/worker']])
    end
  end
end
