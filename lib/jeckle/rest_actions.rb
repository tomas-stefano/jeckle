# frozen_string_literal: true

module Jeckle
  module RESTActions
    module Collection
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      def list(params = {})
        custom_resource_name = params.delete(:resource_name) if params.is_a?(Hash)

        response   = run_request(custom_resource_name || resource_name, params: params).response.body || []
        collection = response.is_a?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
      end

      def create(attrs = {})
        response = run_request(resource_name, method: :post, body: attrs).response.body

        new response
      end

      def update(id, attrs = {})
        endpoint = "#{resource_name}/#{id}"
        response = run_request(endpoint, method: :patch, body: attrs).response.body

        new response
      end

      def destroy(id)
        endpoint = "#{resource_name}/#{id}"
        run_request(endpoint, method: :delete)
        true
      end

      def list_each(per_page: Jeckle::Collection::DEFAULT_PER_PAGE, **params)
        Jeckle::Collection.new(resource_class: self, per_page: per_page, params: params)
      end

      def search(params = {})
        warn '[DEPRECATION] `search` is deprecated. Please use `list` instead.'
        list(params)
      end
    end
  end
end
