# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `find` class method for fetching a single resource by ID.
    #
    # @example
    #   class Shot < Jeckle::Resource
    #     extend Jeckle::Operations::Find
    #   end
    #
    #   Shot.find(123)
    module Find
      # Fetch a single resource by ID.
      #
      # @param id [Integer, String] the resource ID
      # @return [Jeckle::Resource]
      #
      # @example
      #   Shot.find(1600459)
      def find(id)
        endpoint = "#{resource_name}/#{id}"
        attributes = run_request(endpoint).response.body

        new attributes
      end
    end
  end
end
