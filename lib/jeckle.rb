require 'active_model'
require 'faraday'
require 'faraday_middleware'
require 'virtus'

require 'jeckle/version'

%w(setup api model request resource errors).each do |file_name|
  require "jeckle/#{file_name}"
end

module Jeckle
  include Jeckle::Errors

  # Configure APIs to be used on Jeckle::Resources.
  # See Jeckle::Setup for more information.
  #
  def self.configure
    yield Jeckle::Setup
  end
end
