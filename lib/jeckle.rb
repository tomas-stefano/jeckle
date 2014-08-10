require 'active_model'
require 'faraday'
require 'virtus'

require 'jeckle/version'

module Jeckle
  autoload :API, 'jeckle/api'
  autoload :Resource, 'jeckle/resource'
  autoload :Setup, 'jeckle/setup'

  # Configure APIs to be used on Jeckle::Resources.
  #
  # @example
  #
  #    Jeckle.configure do |config|
  #      config.register :my_api_restful do |api|
  #        api.base_uri   = 'myapi.com'
  #        api.headers    = { 'Content-Type' => 'application/whatever.complex.header.v2+json;charset=UTF-8' }
  #        api.logger     = Rails.logger # or any other logger
  #        api.basic_auth = { username: 'chucknorris', password: 'nowThatYouKnowYouMustDie' }
  #      end
  #    end
  #
  def self.configure
    yield Jeckle::Setup
  end
end
