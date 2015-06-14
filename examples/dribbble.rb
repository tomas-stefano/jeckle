require 'jeckle'

# Here is an example using the Dribbble API

Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
    api.middlewares do
      response :json
    end
  end
end

class Shot
  include Jeckle::Resource

  api :dribbble

  action :like, on: :member, method: :post, params: -> { { id: id } }

  attribute :id, Integer
  attribute :name, String
  attribute :url, String
  attribute :image_url, String, as: :image
end

shot = Shot.find 1600459

puts "The shot id is #{shot.id}"
# => 1600459

puts "The shot name is #{shot.name}"
# => Daryl Heckle And Jeckle Oates

puts "The shot image URL is #{shot.image}"
# => https://d13yacurqjgara.cloudfront.net/users/85699/screenshots/1600459/daryl_heckle_and_jeckle_oates-dribble.jpg

# Like this post :)
shot.like
# => post http://api.dribbble.com/shots/1600459/like?id=1600459
