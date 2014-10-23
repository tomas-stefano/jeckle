class CommentLegacy
  include Jeckle::Resource
  api :my_super_api
  root collection: 'super-comments', member: true
  attribute :id, Integer
end