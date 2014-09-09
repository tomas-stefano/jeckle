module Jeckle
  class Setup
    # Register apis, passing all the configurations to it.
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
    def self.register(name)
      Jeckle::API.new.tap do |user_api|
        yield user_api
        registered_apis[name] = user_api
      end
    end

    def self.registered_apis
      @registered_apis ||= {}
    end
  end
end
