# frozen_string_literal: true

module Jeckle
  # Test mode support for Jeckle. When enabled, uses Faraday's test adapter
  # to stub HTTP requests without making real network calls.
  #
  # @example Enable test mode
  #   Jeckle.test_mode!
  #
  # @example Stub a request
  #   Jeckle.stub_request(:my_api, :get, 'users/1') do |stub|
  #     stub.to_return(status: 200, body: '{"id":1,"name":"Test"}')
  #   end
  #
  #   User.find(1) #=> uses stubbed response
  #
  # @example Reset stubs
  #   Jeckle.reset_test_stubs!
  module Testing
    # @return [Hash{Symbol => Faraday::Adapter::Test::Stubs}]
    def self.stubs
      @stubs ||= {}
    end

    # Get or create stubs for an API.
    #
    # @param api_name [Symbol] registered API name
    # @return [Faraday::Adapter::Test::Stubs]
    def self.stubs_for(api_name)
      stubs[api_name] ||= Faraday::Adapter::Test::Stubs.new
    end

    # Reset all test stubs.
    #
    # @return [void]
    def self.reset!
      @stubs = {}
    end
  end

  class << self
    # Enable test mode. Reconfigures all registered API connections to use
    # the Faraday test adapter.
    #
    # @return [void]
    def test_mode!
      @test_mode = true
    end

    # Check if test mode is enabled.
    #
    # @return [Boolean]
    def test_mode?
      @test_mode == true
    end

    # Stub an HTTP request for a registered API.
    #
    # @param api_name [Symbol] registered API name
    # @param method [Symbol] HTTP method (:get, :post, :patch, :delete)
    # @param path [String] URL path to match
    # @param status [Integer] response status code
    # @param body [String, Hash] response body (Hash will be JSON-encoded)
    # @param headers [Hash] response headers
    # @return [void]
    def stub_request(api_name, method, path, status: 200, body: '{}', headers: {})
      body = JSON.generate(body) if body.is_a?(Hash)

      stubs = Testing.stubs_for(api_name)
      stubs.public_send(method, path) { [status, headers, body] }

      api = Jeckle::Setup.registered_apis[api_name]
      return unless api

      api.instance_variable_set(:@connection, nil)
      api.configure_connection do |conn|
        conn.adapter :test, stubs
      end
    end

    # Reset all test stubs and disable test mode.
    #
    # @return [void]
    def reset_test_stubs!
      @test_mode = false
      Testing.reset!
    end
  end
end
