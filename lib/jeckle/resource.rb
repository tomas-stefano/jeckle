module Jeckle
  module Resource
    def self.included(base)
      base.send :include, Jeckle::Model
      base.send :include, ActiveModel::Naming

      base.send :extend, Jeckle::Resource::ClassMethods
    end

    module ClassMethods
      def resource_name
        model_name.element.pluralize
      end

      def default_api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError => e
        raise Jeckle::NoSuchAPIError.new(registered_api_name)
      end

      def api_mapping
        @api_mapping ||= {}
      end

      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      def search(params = {})
        collection = run_request(resource_name, params).response.body || []

        collection.collect { |attrs| new attrs }
      end

      def run_request(endpoint, options = {})
        Jeckle::Request.run api_mapping[:default_api], endpoint, options
      end
    end
  end
end
