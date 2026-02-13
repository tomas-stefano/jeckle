# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `list`, `list_each`, and `search` class methods for fetching resource collections.
    #
    # @example
    #   Shot.list(name: 'avengers')
    #   Shot.list_each(per_page: 10).each { |s| puts s.name }
    #
    # @example Nested resource
    #   Comment.list(post_id: 123)  # GET /posts/123/comments
    module List
      # Fetch a collection of resources.
      #
      # @param params [Hash] query parameters for filtering
      # @option params [String] :resource_name override the default endpoint
      # @return [Array<Jeckle::Resource>]
      #
      # @example
      #   Shot.list(name: 'avengers')
      def list(params = {})
        params = params.dup if params.is_a?(Hash)
        custom_resource_name = params.delete(:resource_name) if params.is_a?(Hash)
        endpoint = custom_resource_name || resolve_endpoint(params)

        response   = run_request(endpoint, params: params).response.body || []
        collection = response.is_a?(Array) ? response : response[resource_name]

        Array(collection).collect { |attrs| new attrs }
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
        endpoint = resolve_endpoint(params)
        strategy = api_mapping[:default_api]&.pagination_strategy
        Jeckle::Collection.new(
          resource_class: self, endpoint: endpoint, per_page: per_page,
          params: params, strategy: strategy
        )
      end

      # @deprecated Use {#list} instead.
      def search(params = {})
        warn '[DEPRECATION] `search` is deprecated. Please use `list` instead.'
        list(params)
      end
    end
  end
end
