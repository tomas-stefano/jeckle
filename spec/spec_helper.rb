if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter 'spec' }
end

require 'bundler/setup'
require 'jeckle'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

require 'fixtures/jeckle_config'

Dir['spec/fixtures/**/*.rb'].each { |file| require File.expand_path(file) }

RSpec.configure do |config|
  config.disable_monkey_patching!
end
