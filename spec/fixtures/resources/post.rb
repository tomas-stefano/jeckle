class Post
  include Jeckle::Resource
  api :my_super_api
  root collection: true, member: true
  attribute :id, Integer

  def ==(other)
    id == other.id
  end
end