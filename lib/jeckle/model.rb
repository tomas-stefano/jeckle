# frozen_string_literal: true

module Jeckle
  class Model < Dry::Struct
    transform_keys(&:to_sym)
    transform_types(&:omittable)

    include ActiveModel::Validations
  end
end
