module Jeckle
  module Resource
    def self.included(base)
      base.send :include, Jeckle::Model
      base.send :include, ActiveModel::Naming

      base.send :extend, Jeckle::Resource::ClassMethods
    end

    module ClassMethods
      def resource_name
        model_name.plural
      end

      def default_api(registered_api_name)
        api_mapping[:default_api] = Jeckle::Setup.registered_apis.fetch(registered_api_name)
      rescue KeyError => e
        raise Jeckle::Setup::NoSuchAPIError.new(registered_api_name)
      end

      def api_mapping
        @api_mapping ||= {}
      end

      def find(id)
        endpoint = "#{resource_name}/#{id}"

        new request(endpoint).response.body
      end

      private

      def request(endpoint, options = {})
        Jeckle::Request.run_request api_mapping[:default_api], endpoint
      end
    end
  end
end
