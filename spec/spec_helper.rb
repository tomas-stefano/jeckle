require 'bundler/setup'

Bundler.require

require 'jeckle'

RSpec.configure do |config|
  config.before :suite do
    class FakeResource
      include Jeckle::Resource
    end
  end
end
