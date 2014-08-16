require 'bundler/setup'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

require 'jeckle'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.before :suite do
    Jeckle::Setup.register(:my_super_api) do |api|
      api.base_uri = 'http://my-super-api.com.br'
      api.headers = { 'Content-Type' => 'application/json' }
      api.logger = Logger.new(STDOUT)
      api.basic_auth = { username: 'steven_seagal', password: 'youAlwaysLose' }
      api.namespaces = { prefix: 'api', version: 'v1' }
      api.params = { hello: 'world' }
    end

    class FakeModel
      include Jeckle::Model
    end

    class FakeResource
      include Jeckle::Resource

      default_api :my_super_api

      attribute :id, Integer
    end
  end
end
