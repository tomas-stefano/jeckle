require 'active_model'
require 'faraday'
require 'faraday_middleware'
require 'virtus'
require 'active_support/core_ext/array/wrap'

require 'jeckle/version'

%w(setup api model request http errors resource).each do |file_name|
  require "jeckle/#{file_name}"
end

module Jeckle
  # Configure APIs to be used on Jeckle::Resources.
  # See Jeckle::Setup for more information.
  #
  def self.configure
    yield Jeckle::Setup
  end
end
