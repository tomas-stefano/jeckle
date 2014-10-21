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
      #     default_api :dribbble
      #   end
      #
      def default_api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError => e
        raise Jeckle::NoSuchAPIError, registered_api_name
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