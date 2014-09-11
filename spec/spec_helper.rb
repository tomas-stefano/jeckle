require 'bundler/setup'
require 'jeckle'
require 'fixtures/jeckle_config'

%w(support fixtures).each do |dir|
  Dir["spec/#{dir}/**/*.rb"].each { |file| require File.expand_path(file) }
end

RSpec.configure do |config|
  config.disable_monkey_patching!
end
