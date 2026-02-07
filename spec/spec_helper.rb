# frozen_string_literal: true

require 'bundler/setup'
require 'ostruct'
require 'jeckle'

Dir['spec/support/**/*.rb'].each { |file| require File.expand_path(file) }

require 'fixtures/jeckle_config'

Dir['spec/fixtures/**/*.rb'].each { |file| require File.expand_path(file) }

RSpec.configure(&:disable_monkey_patching!)
