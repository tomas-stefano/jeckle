class PostLegacy
  include Jeckle::Resource

  api :my_super_api
  root collection: 'super-posts', member: 'super-post'

  attribute :id, Integer
end
