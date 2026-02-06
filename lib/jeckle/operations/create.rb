# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `create` class method for creating resources via POST.
    #
    # @example
    #   Shot.create(name: 'New Shot', url: 'http://example.com')
    #
    # @example Nested resource
    #   Comment.create(post_id: 123, body: 'Great post!')
    module Create
      # Create a new resource via POST.
      #
      # @param attrs [Hash] attributes for the new resource (may include parent IDs)
      # @return [Jeckle::Resource] the created resource
      #
      # @example
      #   Shot.create(name: 'New Shot', url: 'http://example.com')
      def create(attrs = {})
        attrs = attrs.dup
        endpoint = resolve_endpoint(attrs)
        response = run_request(endpoint, method: :post, body: attrs).response.body

        new response
      end
    end
  end
end
