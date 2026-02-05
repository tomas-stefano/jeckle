# frozen_string_literal: true

module Jeckle
  class Collection
    include Enumerable

    DEFAULT_PER_PAGE = 25

    def initialize(resource_class:, endpoint: nil, per_page: DEFAULT_PER_PAGE,
                   params: {}, page_param: :page, per_page_param: :per_page)
      @resource_class = resource_class
      @endpoint = endpoint || resource_class.resource_name
      @per_page = per_page
      @params = params
      @page_param = page_param
      @per_page_param = per_page_param
    end

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

    def page(number)
      page_params = @params.merge(@page_param => number, @per_page_param => @per_page)
      response = @resource_class.run_request(@endpoint, params: page_params).response.body || []
      collection = response.is_a?(Array) ? response : response[@endpoint]

      Array(collection).collect { |attrs| @resource_class.new(attrs) }
    end
  end
end
