require 'bundler/setup'
require 'jeckle'

%w(support fixtures).each do |dir|
  Dir["spec/#{dir}/**/*.rb"].each { |file| require File.expand_path(file) }
end

RSpec.configure do |config|
  config.disable_monkey_patching!
end
