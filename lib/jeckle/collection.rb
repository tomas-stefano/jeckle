# frozen_string_literal: true

module Jeckle
  # Lazy paginated collection that fetches pages on demand using pluggable strategies.
  # Includes Enumerable for standard Ruby collection methods.
  #
  # @example Offset-based (default)
  #   Shot.list_each(per_page: 10).each { |shot| puts shot.name }
  #
  # @example Cursor-based
  #   collection = Jeckle::Collection.new(
  #     resource_class: Shot,
  #     strategy: Jeckle::Pagination::Cursor.new(cursor_param: :starting_after)
  #   )
  class Collection
    include Enumerable

    # @return [Integer] default number of items per page
    DEFAULT_PER_PAGE = 25

    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param endpoint [String, nil] custom endpoint (defaults to resource_name)
    # @param per_page [Integer] number of items per page
    # @param params [Hash] additional query parameters
    # @param strategy [#paginate, #next_context] pagination strategy (defaults to Offset)
    # @param page_param [Symbol] the query parameter name for page number (offset strategy only)
    # @param per_page_param [Symbol] the query parameter name for page size (offset strategy only)
    def initialize(resource_class:, endpoint: nil, per_page: DEFAULT_PER_PAGE,
                   params: {}, strategy: nil, page_param: :page, per_page_param: :per_page)
      @resource_class = resource_class
      @endpoint = endpoint || resource_class.resource_name
      @per_page = per_page
      @params = params
      @strategy = strategy || Jeckle::Pagination::Offset.new(
        page_param: page_param, per_page_param: per_page_param
      )
    end

    # Lazily iterate through all pages of resources.
    # Stops when the strategy indicates no more pages.
    #
    # @yield [resource] each resource from all pages
    # @yieldparam resource [Jeckle::Resource]
    # @return [Enumerator] if no block is given
    def each(&block)
      return enum_for(:each) unless block

      context = {}

      loop do
        records, response = fetch_page(context)
        break if records.empty?

        records.each(&block)

        context = @strategy.next_context(records, @per_page, response, context)
        break unless context
      end
    end

    # Fetch a single page of resources (offset-based convenience method).
    #
    # @param number [Integer] the page number (1-indexed)
    # @return [Array<Jeckle::Resource>]
    def page(number)
      context = { page: number }
      records, = fetch_page(context)
      records
    end

    private

    def fetch_page(context)
      page_params = @strategy.paginate(@params, @per_page, context)
      request = @resource_class.run_request(@endpoint, params: page_params)
      response = request.response
      body = response.body || []
      collection = body.is_a?(Array) ? body : body[@endpoint]

      records = Array(collection).collect { |attrs| @resource_class.new(attrs) }
      [records, response]
    end
  end
end
