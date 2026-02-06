# frozen_string_literal: true

module Jeckle
  module Pagination
    # Offset-based pagination strategy using page number and per_page params.
    #
    # @example
    #   strategy = Offset.new(page_param: :page, per_page_param: :per_page)
    #   # Generates: ?page=1&per_page=25
    class Offset
      # @param page_param [Symbol] query parameter for page number
      # @param per_page_param [Symbol] query parameter for page size
      def initialize(page_param: :page, per_page_param: :per_page)
        @page_param = page_param
        @per_page_param = per_page_param
      end

      # @param params [Hash] base query params
      # @param per_page [Integer] items per page
      # @param context [Hash] pagination state (:page)
      # @return [Hash] merged params with pagination
      def paginate(params, per_page, context)
        page = context[:page] || 1
        params.merge(@page_param => page, @per_page_param => per_page)
      end

      # @param records [Array] current page results
      # @param per_page [Integer] expected page size
      # @param _response [Faraday::Response] the raw response
      # @param context [Hash] current pagination state
      # @return [Hash, nil] next context, or nil if no more pages
      def next_context(records, per_page, _response, context)
        return nil if records.empty? || records.size < per_page

        { page: (context[:page] || 1) + 1 }
      end
    end
  end
end
