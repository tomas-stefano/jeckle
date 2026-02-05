# frozen_string_literal: true

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

class Shot < Jeckle::Resource
  api :dribbble

  attribute :id, Jeckle::Types::Integer
  attribute :name, Jeckle::Types::String
  attribute :url, Jeckle::Types::String
  attribute :image_url, Jeckle::Types::String, as: :image
end

shot = Shot.find 1_600_459

puts "The shot id is #{shot.id}"
# => 1600459

puts "The shot name is #{shot.name}"
# => Daryl Heckle And Jeckle Oates

puts "The shot image URL is #{shot.image}"
# => https://d13yacurqjgara.cloudfront.net/users/85699/screenshots/1600459/daryl_heckle_and_jeckle_oates-dribble.jpg
