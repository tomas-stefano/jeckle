# frozen_string_literal: true

module Jeckle
  module RESTActions
    module Collection
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      def search(params = {})
        custom_resource_name = params.delete(:resource_name) if params.is_a?(Hash)

        response   = run_request(custom_resource_name || resource_name, params: params).response.body || []
        collection = response.is_a?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
      end
    end
  end
end
