# frozen_string_literal: true

module Jeckle
  # Provides `belongs_to` for building nested resource paths.
  #
  # @example
  #   class Comment < Jeckle::Resource
  #     belongs_to :post
  #     attribute :id, Jeckle::Types::Integer
  #     attribute :body, Jeckle::Types::String
  #   end
  #
  #   Comment.find(456, post_id: 123)  # GET /posts/123/comments/456
  #   Comment.list(post_id: 123)       # GET /posts/123/comments
  module NestedResource
    # Declare a parent resource for nested URL paths.
    #
    # @param parent_name [Symbol] the singular parent resource name
    #
    # @example
    #   belongs_to :post
    def belongs_to(parent_name)
      @parent_resource = parent_name
    end

    # @return [Symbol, nil] the parent resource name, if any
    def parent_resource
      @parent_resource
    end

    # Resolve the base endpoint, prepending parent path if nested.
    # Extracts and removes parent ID from params when a parent is declared.
    #
    # @param params [Hash] may contain :<parent>_id for nested resources
    # @return [String] the base endpoint path
    def resolve_endpoint(params = {})
      if parent_resource
        parent_id_key = :"#{parent_resource}_id"
        parent_id = params.delete(parent_id_key)

        raise Jeckle::ArgumentError, "#{parent_id_key} is required for nested resource" unless parent_id

        "#{parent_resource}s/#{parent_id}/#{resource_name}"
      else
        resource_name
      end
    end
  end
end
