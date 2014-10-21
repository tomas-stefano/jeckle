class FakeResource
  include Jeckle::Resource

  api :my_super_api

  attribute :id, Integer
end