if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'bundler/setup'
require 'pry' unless RUBY_ENGINE == 'rbx'
require 'jeckle'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

require 'fixtures/jeckle_config'

Dir['spec/fixtures/**/*.rb'].each { |file| require File.expand_path(file) }

RSpec.configure do |config|
  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
