# frozen_string_literal: true

require 'monitor'

module Jeckle
  # Central registry for API configurations. Thread-safe via Monitor.
  #
  # @example
  #   Jeckle.configure do |config|
  #     config.register :my_api do |api|
  #       api.base_uri = 'https://api.example.com'
  #       api.bearer_token = 'my-token'
  #     end
  #   end
  class Setup
    @monitor = Monitor.new

    # Register a new API configuration.
    #
    # @param name [Symbol] unique name for this API
    # @yield [Jeckle::API] the API instance to configure
    # @return [Jeckle::API] the configured API
    # @raise [LocalJumpError] if no block is given
    def self.register(name)
      Jeckle::API.new.tap do |user_api|
        yield user_api
        @monitor.synchronize { registered_apis[name] = user_api }
      end
    end

    # Returns all registered APIs.
    #
    # @return [Hash{Symbol => Jeckle::API}]
    def self.registered_apis
      @registered_apis ||= {}
    end

    # Reset all registered APIs. Useful for testing.
    #
    # @return [void]
    def self.reset!
      @monitor.synchronize { @registered_apis = {} }
    end
  end
end
