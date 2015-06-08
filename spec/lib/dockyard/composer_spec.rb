require 'spec_helper'

describe Dockyard::Composer do

  describe '.compose' do
    subject { Dockyard::Composer.compose(services) }

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
      {
        foo: foo_configuration,
        bar: bar_configuration
      }
    end

    it 'concatenates services\' compose configurations' do
      expect(subject.keys).to eq(foo_configuration.keys + bar_configuration.keys)
    end

    it 'replaces path references for "build" keys' do
      build_values = subject.map { |service, config| config['build'] }.compact

      expect(build_values).to eq(['./foo/service/', './foo/redis/', './bar/service/'])
    end

    it 'replaces path references for "volumes" keys' do
      volumes_values = subject.map { |service, config| config['volumes'] }.compact

      expect(volumes_values).to eq([['./foo/service/foo:/root/worker'], ['./bar/service/bar:/root/worker']])
    end

  end

end
