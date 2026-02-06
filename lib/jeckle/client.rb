# frozen_string_literal: true

module Jeckle
  # Instance-based client for making requests with different credentials
  # or configurations without affecting global state.
  #
  # @example
  #   client = Jeckle::Client.new(:my_api, bearer_token: 'other-token')
  #   client.find(Shot, 123)
  #   client.list(Shot, name: 'avengers')
  class Client
    # @param api_name [Symbol] registered API name
    # @param overrides [Hash] configuration overrides
    # @option overrides [String] :bearer_token override bearer token
    # @option overrides [Hash] :api_key override API key config
    def initialize(api_name, **overrides)
      base_api = Jeckle::Setup.registered_apis.fetch(api_name) do
        raise Jeckle::NoSuchAPIError, api_name
      end

      @api = clone_api(base_api, overrides)
    end

    # @return [Jeckle::API] the client's API configuration
    attr_reader :api

    # Fetch a single resource by ID.
    #
    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param id [Integer, String] the resource ID
    # @return [Jeckle::Resource]
    def find(resource_class, id)
      endpoint = "#{resource_class.resource_name}/#{id}"
      attrs = run_request(resource_class, endpoint).response.body
      resource_class.new(attrs)
    end

    # Fetch a collection of resources.
    #
    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param params [Hash] query parameters
    # @return [Array<Jeckle::Resource>]
    def list(resource_class, params = {})
      endpoint = resource_class.resource_name
      response = run_request(resource_class, endpoint, params: params).response.body || []
      collection = response.is_a?(Array) ? response : response[endpoint]
      Array(collection).collect { |attrs| resource_class.new(attrs) }
    end

    # Create a resource via POST.
    #
    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param attrs [Hash] attributes
    # @return [Jeckle::Resource]
    def create(resource_class, attrs = {})
      endpoint = resource_class.resource_name
      response = run_request(resource_class, endpoint, method: :post, body: attrs).response.body
      resource_class.new(response)
    end

    # Update a resource via PATCH.
    #
    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param id [Integer, String] the resource ID
    # @param attrs [Hash] attributes to update
    # @return [Jeckle::Resource]
    def update(resource_class, id, attrs = {})
      endpoint = "#{resource_class.resource_name}/#{id}"
      response = run_request(resource_class, endpoint, method: :patch, body: attrs).response.body
      resource_class.new(response)
    end

    # Delete a resource via DELETE.
    #
    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param id [Integer, String] the resource ID
    # @return [true]
    def destroy(resource_class, id)
      endpoint = "#{resource_class.resource_name}/#{id}"
      run_request(resource_class, endpoint, method: :delete)
      true
    end

    private

    def run_request(_resource_class, endpoint, options = {})
      Jeckle::Request.run(@api, endpoint, options)
    end

    def clone_api(base_api, overrides)
      Jeckle::API.new.tap do |api|
        api.base_uri = base_api.instance_variable_get(:@base_uri)
        api.namespaces = base_api.namespaces if base_api.namespaces.any?
        api.headers = base_api.headers if base_api.headers.any?
        api.params = base_api.instance_variable_get(:@params) if base_api.instance_variable_get(:@params)
        api.open_timeout = base_api.instance_variable_get(:@open_timeout)
        api.read_timeout = base_api.instance_variable_get(:@read_timeout)
        api.bearer_token = overrides[:bearer_token] || base_api.bearer_token
        api.api_key = overrides[:api_key] if overrides[:api_key] || base_api.api_key
      end
    end
  end
end
