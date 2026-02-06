# frozen_string_literal: true

module Jeckle
  # Dry::Types container for attribute type definitions.
  #
  # @example
  #   class Shot < Jeckle::Resource
  #     attribute :id, Jeckle::Types::Integer
  #     attribute :name, Jeckle::Types::String
  #     attribute :score, Jeckle::Types::Float
  #     attribute :active, Jeckle::Types::Bool
  #   end
  module Types
    include Dry.Types()
  end
end
