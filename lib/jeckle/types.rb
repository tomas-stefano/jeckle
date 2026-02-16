# frozen_string_literal: true

require 'bigdecimal'
require 'time'
require 'uri'

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

    DateTime = Constructor(::DateTime) do |value|
      case value
      when ::Time then value.to_datetime
      when ::String then ::DateTime.parse(value)
      when ::Integer, ::Float then ::Time.at(value).to_datetime
      else value
      end
    end

    Time = Constructor(::Time) do |value|
      case value
      when ::String then ::Time.parse(value)
      when ::Integer, ::Float then ::Time.at(value)
      else value
      end
    end

    Decimal = Constructor(::BigDecimal) do |value|
      case value
      when ::BigDecimal then value
      else BigDecimal(value.to_s)
      end
    end

    UUID = String.constrained(
      format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
    )

    URI = Constructor(::URI) do |value|
      case value
      when ::URI then value
      else ::URI.parse(value.to_s)
      end
    end

    SymbolizedHash = Constructor(::Hash) do |value|
      value.transform_keys(&:to_sym)
    end

    StringArray = Types::Array.of(Types::Coercible::String)
  end
end
