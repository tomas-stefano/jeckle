module Jeckle
  module RESTActions
    def self.included(base)
      base.send :extend, Jeckle::RESTActions::Collection
    end

    module Collection
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      def search(params = {})
        response   = run_request(resource_name, params).response.body || []
        collection = response.kind_of?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
      end
    end
  end
end