require 'delegate'

module Jeckle
  class CollectionResponse < SimpleDelegator
    attr_reader :response, :collection

    def initialize(collection, context: context, response: response)
      @collection = Array(collection).map do |attributes|
        context.new(attributes)
      end

      @response = response

      super(@collection)
    end

    def body
      @response.body
    end

    def headers
      @response.headers
    end
  end
end