# frozen_string_literal: true

module Jeckle
  # Central registry for API configurations.
  #
  # @example
  #   Jeckle.configure do |config|
  #     config.register :my_api do |api|
  #       api.base_uri = 'https://api.example.com'
  #       api.bearer_token = 'my-token'
  #     end
  #   end
  class Setup
    # Register a new API configuration.
    #
    # @param name [Symbol] unique name for this API
    # @yield [Jeckle::API] the API instance to configure
    # @return [Jeckle::API] the configured API
    # @raise [LocalJumpError] if no block is given
    def self.register(name)
      Jeckle::API.new.tap do |user_api|
        yield user_api
        registered_apis[name] = user_api
      end
    end

    # Returns all registered APIs.
    #
    # @return [Hash{Symbol => Jeckle::API}]
    def self.registered_apis
      @registered_apis ||= {}
    end
  end
end
