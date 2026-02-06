# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `update` class method for updating resources via PATCH.
    #
    # @example
    #   class Shot < Jeckle::Resource
    #     extend Jeckle::Operations::Update
    #   end
    #
    #   Shot.update(123, name: 'Updated Name')
    module Update
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
    end
  end
end
