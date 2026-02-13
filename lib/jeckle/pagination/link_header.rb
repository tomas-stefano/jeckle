# frozen_string_literal: true

module Jeckle
  module Pagination
    # Link header pagination strategy that follows RFC 5988 `Link` headers.
    # Common in GitHub API and similar REST APIs.
    #
    # @example
    #   strategy = LinkHeader.new(per_page_param: :per_page)
    #   # First request:  ?per_page=25
    #   # Next request:   follows URL from Link header rel="next"
    class LinkHeader
      # @param per_page_param [Symbol] query parameter for page size
      def initialize(per_page_param: :per_page)
        @per_page_param = per_page_param
      end

      # @param params [Hash] base query params
      # @param per_page [Integer] items per page
      # @param context [Hash] pagination state (:next_params)
      # @return [Hash] merged params with pagination
      def paginate(params, per_page, context)
        params.merge(context[:next_params] || { @per_page_param => per_page })
      end

      # @param records [Array] current page results
      # @param _per_page [Integer] expected page size
      # @param response [Faraday::Response] the raw response
      # @param _context [Hash] current pagination state
      # @return [Hash, nil] next context, or nil if no more pages
      def next_context(records, _per_page, response, _context)
        return nil if records.empty?

        next_url = extract_next_url(response)
        return nil unless next_url

        { next_params: extract_query_params(next_url) }
      end

      private

      def extract_next_url(response)
        headers = response&.headers
        return unless headers

        link_header = headers['Link'] || headers['link']
        return unless link_header

        parse_next_link(link_header)
      end

      def parse_next_link(header)
        header.split(',').each do |part|
          match = part.match(/<([^>]+)>;\s*rel="next"/)
          return match[1] if match
        end
        nil
      end

      def extract_query_params(url)
        uri = URI.parse(url)
        return {} unless uri.query

        URI.decode_www_form(uri.query).to_h.transform_keys(&:to_sym)
      end
    end
  end
end
