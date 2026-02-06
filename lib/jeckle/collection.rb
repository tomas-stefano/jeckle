# frozen_string_literal: true

module Jeckle
  # Lazy, offset-based paginated collection that fetches pages on demand.
  # Includes Enumerable for standard Ruby collection methods.
  #
  # @example Iterate through all resources
  #   Shot.list_each(per_page: 10).each { |shot| puts shot.name }
  #
  # @example Fetch a specific page
  #   collection = Jeckle::Collection.new(resource_class: Shot, per_page: 10)
  #   page_3 = collection.page(3)
  class Collection
    include Enumerable

    # @return [Integer] default number of items per page
    DEFAULT_PER_PAGE = 25

    # @param resource_class [Class] the Jeckle::Resource subclass
    # @param endpoint [String, nil] custom endpoint (defaults to resource_name)
    # @param per_page [Integer] number of items per page
    # @param params [Hash] additional query parameters
    # @param page_param [Symbol] the query parameter name for page number
    # @param per_page_param [Symbol] the query parameter name for page size
    def initialize(resource_class:, endpoint: nil, per_page: DEFAULT_PER_PAGE,
                   params: {}, page_param: :page, per_page_param: :per_page)
      @resource_class = resource_class
      @endpoint = endpoint || resource_class.resource_name
      @per_page = per_page
      @params = params
      @page_param = page_param
      @per_page_param = per_page_param
    end

    # Lazily iterate through all pages of resources.
    # Stops when a page returns fewer results than per_page or is empty.
    #
    # @yield [resource] each resource from all pages
    # @yieldparam resource [Jeckle::Resource]
    # @return [Enumerator] if no block is given
    def each(&block)
      return enum_for(:each) unless block

      page_number = 1

      loop do
        records = page(page_number)
        break if records.empty?

        records.each(&block)
        break if records.size < @per_page

        page_number += 1
      end
    end

    # Fetch a single page of resources.
    #
    # @param number [Integer] the page number (1-indexed)
    # @return [Array<Jeckle::Resource>]
    def page(number)
      page_params = @params.merge(@page_param => number, @per_page_param => @per_page)
      response = @resource_class.run_request(@endpoint, params: page_params).response.body || []
      collection = response.is_a?(Array) ? response : response[@endpoint]

      Array(collection).collect { |attrs| @resource_class.new(attrs) }
    end
  end
end
