# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `find` class method for fetching a single resource by ID.
    #
    # @example
    #   Shot.find(123)
    #
    # @example Nested resource
    #   Comment.find(456, post_id: 123)  # GET /posts/123/comments/456
    module Find
      # Fetch a single resource by ID.
      #
      # @param id [Integer, String] the resource ID
      # @param params [Hash] optional params (e.g., parent IDs for nested resources)
      # @return [Jeckle::Resource]
      #
      # @example
      #   Shot.find(1600459)
      def find(id, params = {})
        base = resolve_endpoint(params)
        endpoint = "#{base}/#{id}"
        request = run_request(endpoint)
        resource = new(request.response.body)
        resource._response = request.response if resource.respond_to?(:_response=)
        resource
      end
    end
  end
end
