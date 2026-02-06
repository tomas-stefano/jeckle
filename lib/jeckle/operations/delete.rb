# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `destroy` class method for deleting resources via DELETE.
    #
    # @example
    #   class Shot < Jeckle::Resource
    #     extend Jeckle::Operations::Delete
    #   end
    #
    #   Shot.destroy(123)
    module Delete
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
    end
  end
end
