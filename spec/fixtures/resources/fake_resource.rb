# frozen_string_literal: true

class FakeResource < Jeckle::Resource
  api :my_super_api

  attribute :id, Jeckle::Types::Integer
end
