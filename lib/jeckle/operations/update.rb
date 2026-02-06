# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `update` class method for updating resources via PATCH.
    #
    # @example
    #   Shot.update(123, name: 'Updated Name')
    #
    # @example Nested resource
    #   Comment.update(456, post_id: 123, body: 'Updated body')
    module Update
      # Update an existing resource via PATCH.
      #
      # @param id [Integer, String] the resource ID
      # @param attrs [Hash] attributes to update (may include parent IDs)
      # @return [Jeckle::Resource] the updated resource
      #
      # @example
      #   Shot.update(123, name: 'Updated Name')
      def update(id, attrs = {})
        attrs = attrs.dup
        base = resolve_endpoint(attrs)
        endpoint = "#{base}/#{id}"
        response = run_request(endpoint, method: :patch, body: attrs).response.body

        new response
      end
    end
  end
end
