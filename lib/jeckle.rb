require 'active_model'
require 'faraday'
require 'virtus'

require 'jeckle/version'

module Jeckle
  autoload :API, 'jeckle/api'
  autoload :Resource, 'jeckle/resource'
  autoload :Setup, 'jeckle/setup'

  # Configure APIs to use in all Jeckle::Resources.
  #
  # @example
  #
  #    Jeckle.configure do |config|
  #      config.register :my_api_restful do |api|
  #        api.base_uri   = 'myapi.com'
  #        api.logger     = Rails.logger # or any other logger
  #        api.filter     = [:password, :sensitive_data] # show [FILTERED] in the logger.
  #        api.options    = { version: 'v2' }
  #        api.headers    = { 'Content-Type' => 'application/whatever.complex.header.v2+json;charset=UTF-8' }
  #        api.basic_auth = { username: 'chucknorris', password: 'nowThatYouKnowYouMustDie' }
  #      end
  #    end
  #
  def self.configure
    yield Jeckle::Setup
  end
end