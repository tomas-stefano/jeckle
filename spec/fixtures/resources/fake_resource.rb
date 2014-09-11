class FakeResource
  include Jeckle::Resource

  default_api :my_super_api

  attribute :id, Integer
end