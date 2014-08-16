require 'jeckle'

Jeckle.configure do |config|
  config.register :dribbble do |api|
    api.base_uri = 'http://api.dribbble.com'
  end
end

class Shot
  include Jeckle::Resource

  default_api :dribbble

  attribute :id, Integer
  attribute :name, String
  attribute :url, String
  attribute :image_url, String
end

shot = Shot.find 1600459

shot.id
# => 1600459

shot.name
# => Daryl Heckle And Jeckle Oates

shot.image_url
# => https://d13yacurqjgara.cloudfront.net/users/85699/screenshots/1600459/daryl_heckle_and_jeckle_oates-dribble.jpg
