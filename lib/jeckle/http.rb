module Jeckle
  module HTTP
    def self.included(base)
      base.extend Jeckle::HTTP::APIMapping
    end

    module APIMapping
      def inherited(base)
        base.class_eval do
          @api_mapping = superclass.api_mapping.dup
        end
      end

      # @public
      #
      # The name of the resource that Jeckle uses to make the request
      #
      # @example
      #
      #   module Dribble
      #     class Shot
      #       include Jeckle::Resource
      #     end
      #   end
      #
      #   Shot.resource_name # => Will request for '/shots' resource
      #
      # To overwrite this behaviour, rewrite the resource name method in the class:
      #
      #   module OtherApi
      #     class Project
      #       include Jeckle::Resource
      #
      #       def self.resource_name
      #         '/project'
      #       end
      #     end
      #   end
      #
      def resource_name
        @resource_name ||= model_name.element.pluralize
      end

      # @public
      #
      # Overwritten the resource name without write the resource name method.
      #
      # @example
      #
      #   module OtherApi
      #     class Project
      #       include Jeckle::Resource
      #       resource 'projects.json'
      #     end
      #   end
      #
      def resource(jeckle_resource_name)
        @resource_name = jeckle_resource_name
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
      #   class Shot
      #     include Jeckle::Resource
      #     api :dribbble
      #   end
      #
      def api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError => e
        raise Jeckle::NoSuchAPIError, registered_api_name
      end

      # @deprecated Please use {#api} instead
      #
      def default_api(registered_api_name)
        warn "[DEPRECATION] `default_api` is deprecated.  Please use `api` instead."
        api(registered_api_name)
      end

      def api_mapping
        @api_mapping ||= {}
      end

      def run_request(endpoint, options = {})
        response = Jeckle::Request.run api_mapping[:default_api], endpoint, options

        if logger = api_mapping[:default_api].logger
          logger.debug("#{self} Response: #{response}")
        end

        response
      end
    end
  end
end