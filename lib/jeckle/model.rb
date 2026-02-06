# frozen_string_literal: true

module Jeckle
  # Base class for Jeckle data models. Inherits from Dry::Struct with
  # symbol key transformation and omittable attributes.
  #
  # @example
  #   class User < Jeckle::Model
  #     attribute :name, Jeckle::Types::String
  #     attribute :email, Jeckle::Types::String
  #     validates :name, presence: true
  #   end
  class Model < Dry::Struct
    transform_keys(&:to_sym)
    transform_types(&:omittable)

    include ActiveModel::Validations
  end
end
