# frozen_string_literal: true

module Jeckle
  module Operations
    # Provides `create` class method for creating resources via POST.
    #
    # @example
    #   class Shot < Jeckle::Resource
    #     extend Jeckle::Operations::Create
    #   end
    #
    #   Shot.create(name: 'New Shot', url: 'http://example.com')
    module Create
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
    end
  end
end
