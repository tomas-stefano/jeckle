require 'active_model'
require 'faraday'
require 'faraday_middleware'
require 'virtus'

require 'jeckle/version'

%w(setup api model request resource exceptions).each do |file|
  require "jeckle/#{file}"
end

module Jeckle
  include Jeckle::Exceptions

  # Configure APIs to be used on Jeckle::Resources.
  # See Jeckle::Setup for more information.
  #
  def self.configure
    yield Jeckle::Setup
  end
end
