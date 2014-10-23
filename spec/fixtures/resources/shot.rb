class Shot
  include Jeckle::Resource
  api :my_super_api
  resource 'shots.json'
end