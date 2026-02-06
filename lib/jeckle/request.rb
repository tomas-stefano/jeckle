# frozen_string_literal: true

module Jeckle
  # Performs HTTP requests against a configured API connection.
  class Request
    # @return [Jeckle::API] the API configuration
    # @return [String, nil] the request body
    # @return [Hash, nil] custom request headers
    # @return [Symbol] the HTTP method (:get, :post, :put, :patch, :delete)
    # @return [Hash] query parameters
    # @return [Faraday::Response] the response object
    # @return [String] the request endpoint path
    attr_reader :api, :body, :headers, :method, :params, :response, :endpoint

    def initialize(api, endpoint, options = {})
      @api = api

      @method  = options.delete(:method) || :get
      @body    = options.delete(:body) if %w[post put patch].include?(method.to_s)
      @headers = options.delete(:headers)
      @timeout = options.delete(:timeout)

      if options[:params].nil? && options.size.positive?
        warn %([DEPRECATION] Sending URL params mixed with options hash is deprecated.
        Instead of doing this:
          run_request 'cars/search', id: id, method: :get
        Do this:
          run_request 'cars/search', params: { id: id }, method: :get)

        @params = options
      else
        @params = options.delete(:params) || {}
      end

      @endpoint = endpoint

      @response = perform_api_request
    end

    # Execute an HTTP request.
    #
    # @param api [Jeckle::API] the API configuration
    # @param endpoint [String] the URL path
    # @param options [Hash] request options (:method, :body, :headers, :params)
    # @return [Jeckle::Request]
    def self.run(api, endpoint, options = {})
      new(api, endpoint, options)
    end

    private

    def perform_api_request
      api.connection.public_send method do |api_request|
        api_request.url endpoint
        api_request.params  = params
        api_request.body    = body
        api_request.headers = api_request.headers.merge(headers) if headers
        api_request.options.timeout = @timeout if @timeout
      end
    end
  end
end
