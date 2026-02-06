# frozen_string_literal: true

module Jeckle
  module Pagination
    # Cursor-based pagination strategy using a cursor param (e.g., Stripe's `starting_after`).
    #
    # @example
    #   strategy = Cursor.new(cursor_param: :starting_after, limit_param: :limit)
    #   # First request:  ?limit=25
    #   # Next request:   ?limit=25&starting_after=obj_abc123
    class Cursor
      # @param cursor_param [Symbol] query parameter for cursor value
      # @param limit_param [Symbol] query parameter for page size
      # @param cursor_field [Symbol] field on each record to use as cursor value
      def initialize(cursor_param: :after, limit_param: :limit, cursor_field: :id)
        @cursor_param = cursor_param
        @limit_param = limit_param
        @cursor_field = cursor_field
      end

      # @param params [Hash] base query params
      # @param per_page [Integer] items per page
      # @param context [Hash] pagination state (:cursor)
      # @return [Hash] merged params with pagination
      def paginate(params, per_page, context)
        result = params.merge(@limit_param => per_page)
        result[@cursor_param] = context[:cursor] if context[:cursor]
        result
      end

      # @param records [Array] current page results
      # @param per_page [Integer] expected page size
      # @param _response [Faraday::Response] the raw response
      # @param _context [Hash] current pagination state
      # @return [Hash, nil] next context with cursor, or nil if no more pages
      def next_context(records, per_page, _response, _context)
        return nil if records.empty? || records.size < per_page

        last_record = records.last
        cursor = last_record.respond_to?(@cursor_field) ? last_record.public_send(@cursor_field) : nil
        return nil unless cursor

        { cursor: cursor }
      end
    end
  end
end
