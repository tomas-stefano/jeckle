# frozen_string_literal: true

module Jeckle
  # REST action methods for Jeckle resources.
  module RESTActions
    # Collection-level CRUD operations extended onto resource classes.
    module Collection
      # Fetch a single resource by ID.
      #
      # @param id [Integer, String] the resource ID
      # @return [Jeckle::Resource] an instance of the resource
      #
      # @example
      #   Shot.find(1600459)
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end

      # Fetch a collection of resources.
      #
      # @param params [Hash] query parameters for filtering
      # @option params [String] :resource_name override the default endpoint
      # @return [Array<Jeckle::Resource>]
      #
      # @example
      #   Shot.list(name: 'avengers')
      def list(params = {})
        custom_resource_name = params.delete(:resource_name) if params.is_a?(Hash)

        response   = run_request(custom_resource_name || resource_name, params: params).response.body || []
        collection = response.is_a?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
      end

      # Create a new resource via POST.
      #
      # @param attrs [Hash] attributes for the new resource
      # @return [Jeckle::Resource] the created resource
      #
      # @example
      #   Shot.create(name: 'New Shot', url: 'http://example.com')
      def create(attrs = {})
        response = run_request(resource_name, method: :post, body: attrs).response.body

        new response
      end

      # Update an existing resource via PATCH.
      #
      # @param id [Integer, String] the resource ID
      # @param attrs [Hash] attributes to update
      # @return [Jeckle::Resource] the updated resource
      #
      # @example
      #   Shot.update(123, name: 'Updated Name')
      def update(id, attrs = {})
        endpoint = "#{resource_name}/#{id}"
        response = run_request(endpoint, method: :patch, body: attrs).response.body

        new response
      end

      # Delete a resource via DELETE.
      #
      # @param id [Integer, String] the resource ID
      # @return [true]
      #
      # @example
      #   Shot.destroy(123)
      def destroy(id)
        endpoint = "#{resource_name}/#{id}"
        run_request(endpoint, method: :delete)
        true
      end

      # Returns a lazy paginated collection that fetches pages on demand.
      #
      # @param per_page [Integer] number of items per page
      # @param params [Hash] additional query parameters
      # @return [Jeckle::Collection]
      #
      # @example
      #   Shot.list_each(per_page: 10).each { |shot| puts shot.name }
      def list_each(per_page: Jeckle::Collection::DEFAULT_PER_PAGE, **params)
        Jeckle::Collection.new(resource_class: self, per_page: per_page, params: params)
      end

      # @deprecated Use {#list} instead.
      def search(params = {})
        warn '[DEPRECATION] `search` is deprecated. Please use `list` instead.'
        list(params)
      end
    end
  end
end
