require 'bundler/setup'

Bundler.require

require 'jeckle'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

RSpec.configure do |config|
  config.before :suite do
    class FakeResource
      include Jeckle::Resource
    end
  end
end
