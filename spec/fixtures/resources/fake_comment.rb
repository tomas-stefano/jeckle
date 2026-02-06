# frozen_string_literal: true

class FakeComment < Jeckle::Resource
  api :my_super_api

  belongs_to :post

  attribute :id, Jeckle::Types::Integer
  attribute :body, Jeckle::Types::String
end
