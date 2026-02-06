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

    # Register an API from environment variables.
    # Reads <PREFIX>_BASE_URI, <PREFIX>_BEARER_TOKEN, <PREFIX>_API_KEY.
    #
    # @param name [Symbol] API name (also used as env var prefix when upcased)
    # @param prefix [String, nil] custom env var prefix (defaults to name.upcase)
    # @yield [Jeckle::API] optional block for additional configuration
    # @return [Jeckle::API]
    #
    # @example
    #   # Reads MY_API_BASE_URI, MY_API_BEARER_TOKEN from ENV
    #   Jeckle::Setup.register_from_env(:my_api)
    def self.register_from_env(name, prefix: nil, &block)
      env_prefix = (prefix || name).to_s.upcase

      register(name) do |api|
        api.base_uri = ENV.fetch("#{env_prefix}_BASE_URI")
        api.bearer_token = ENV["#{env_prefix}_BEARER_TOKEN"] if ENV["#{env_prefix}_BEARER_TOKEN"]
        block&.call(api)
      end
    end

    # Reset all registered APIs. Useful for testing.
    #
    # @return [void]
    def self.reset!
      @monitor.synchronize { @registered_apis = {} }
    end
  end
end
