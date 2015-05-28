module Jeckle
  module RESTActions
    def self.included(base)
      base.extend Jeckle::RESTActions::Collection
    end

    module Collection
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      def search(params = {})
        custom_resource_name = params.delete(:resource_name) if params.kind_of?(Hash)

        response   = run_request(custom_resource_name || resource_name, params: params).response.body || []
        collection = response.kind_of?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
      end
    end
  end
end
