# frozen_string_literal: true

module Jeckle
  module HTTP
    module APIMapping
      def inherited(base)
        super
        base.instance_variable_set(:@api_mapping, api_mapping.dup)
      end

      # The name of the resource that Jeckle uses to make the request
      #
      # @example
      #
      #   class Shot < Jeckle::Resource
      #   end
      #
      #   Shot.resource_name # => Will request for '/shots' resource
      #
      # To overwrite this behaviour, rewrite the resource name method in the class:
      #
      #   class Project < Jeckle::Resource
      #     def self.resource_name
      #       '/project'
      #     end
      #   end
      #
      def resource_name
        @resource_name ||= model_name.element.pluralize
      end

      # The API name that Jeckle uses to find all the api settings like domain, headers, etc.
      #
      # @example
      #
      #   Jeckle.configure do |config|
      #     config.register :dribbble do |api|
      #       api.base_uri = 'http://api.dribbble.com'
      #     end
      #   end
      #
      #   class Shot < Jeckle::Resource
      #     api :dribbble
      #   end
      #
      def api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError
        raise Jeckle::NoSuchAPIError, registered_api_name
      end

      # @deprecated Please use {#api} instead
      #
      def default_api(registered_api_name)
        warn '[DEPRECATION] `default_api` is deprecated. Please use `api` instead.'
        api(registered_api_name)
      end

      def api_mapping
        @api_mapping ||= {}
      end

      def run_request(endpoint, options = {})
        Jeckle::Request.run api_mapping[:default_api], endpoint, options
      end
    end
  end
end
