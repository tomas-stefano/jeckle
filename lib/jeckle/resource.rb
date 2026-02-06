# frozen_string_literal: true

module Jeckle
  # Base class for API resources. Provides attribute modeling, HTTP
  # connectivity, REST actions (CRUD), and attribute aliasing.
  #
  # @example
  #   class Shot < Jeckle::Resource
  #     api :dribbble
  #     attribute :id, Jeckle::Types::Integer
  #     attribute :name, Jeckle::Types::String
  #     attribute :image_url, Jeckle::Types::String, as: :image
  #   end
  #
  #   Shot.find(123)
  #   Shot.list(name: 'avengers')
  #   Shot.create(name: 'New Shot')
  class Resource < Jeckle::Model
    include ActiveModel::Naming
    include Jeckle::Operations::Instance
    include Jeckle::ResponseInspector

    extend Jeckle::HTTP::APIMapping
    extend Jeckle::RESTActions::Collection
    extend Jeckle::NestedResource
    extend Jeckle::AttributeAliasing
  end
end
