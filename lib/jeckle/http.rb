# frozen_string_literal: true

module Jeckle
  # HTTP connectivity module for Jeckle resources.
  module HTTP
    # Provides API mapping, resource naming, and request execution.
    module APIMapping
      # @api private
      def inherited(base)
        super
        base.instance_variable_set(:@api_mapping, api_mapping.dup)
      end

      # Returns the pluralized resource name derived from the class name.
      #
      # @return [String]
      #
      # @example
      #   class Shot < Jeckle::Resource; end
      #   Shot.resource_name #=> "shots"
      def resource_name
        @resource_name ||= model_name.element.pluralize
      end

      # Assign a registered API to this resource.
      #
      # @param registered_api_name [Symbol] name used in {Jeckle::Setup.register}
      # @return [Jeckle::API]
      # @raise [Jeckle::NoSuchAPIError] if the API name is not registered
      #
      # @example
      #   class Shot < Jeckle::Resource
      #     api :dribbble
      #   end
      def api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError
        raise Jeckle::NoSuchAPIError, registered_api_name
      end

      # @deprecated Please use {#api} instead
      def default_api(registered_api_name)
        warn '[DEPRECATION] `default_api` is deprecated. Please use `api` instead.'
        api(registered_api_name)
      end

      # @return [Hash] the API mapping for this resource
      def api_mapping
        @api_mapping ||= {}
      end

      # Execute an HTTP request against the configured API.
      #
      # @param endpoint [String] the URL path
      # @param options [Hash] request options passed to {Jeckle::Request.run}
      # @return [Jeckle::Request]
      def run_request(endpoint, options = {})
        Jeckle::Request.run api_mapping[:default_api], endpoint, options
      end
    end
  end
end
