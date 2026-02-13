# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `destroy` class method for deleting resources via DELETE.
    #
    # @example
    #   Shot.destroy(123)
    #
    # @example Nested resource
    #   Comment.destroy(456, post_id: 123)
    module Delete
      # Delete a resource via DELETE.
      #
      # @param id [Integer, String] the resource ID
      # @param params [Hash] optional params (e.g., parent IDs for nested resources)
      # @return [true]
      #
      # @example
      #   Shot.destroy(123)
      def destroy(id, params = {})
        params = params.dup
        base = resolve_endpoint(params)
        endpoint = "#{base}/#{id}"
        run_request(endpoint, method: :delete)
        true
      end
    end
  end
end
