require 'active_model'
require 'faraday'
require 'virtus'

require 'jeckle/version'

module Jeckle
  autoload :API, 'jeckle/api'
  autoload :Model, 'jeckle/model'
  autoload :Request, 'jeckle/request'
  autoload :Setup, 'jeckle/setup'

  # Configure APIs to be used on Jeckle::Resources.
  #
  # @example
  #
  #    Jeckle.configure do |config|
  #      config.register :my_api_restful do |api|
  #        api.basic_auth = { username: 'chucknorris', password: 'nowThatYouKnowYouMustDie' }
  #        api.namespaces = { version: 'v2' }
  #        api.base_uri = 'myapi.com'
  #        api.headers = { 'Content-Type' => 'application/whatever.complex.header.v2+json;charset=UTF-8' }
  #        api.logger = Rails.logger # or any other logger
  #      end
  #    end
  #
  def self.configure
    yield Jeckle::Setup
  end
end
