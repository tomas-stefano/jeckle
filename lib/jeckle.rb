# frozen_string_literal: true

require 'active_model'
require 'dry-struct'
require 'dry/types'
require 'faraday'
require 'faraday/retry'

require 'jeckle/version'

%w[
  types setup api model request http collection operations rest_actions
  nested_resource attribute_aliasing resource errors middleware/raise_error
].each do |file_name|
  require "jeckle/#{file_name}"
end

# Jeckle is a library for building API client wrappers with minimal boilerplate.
#
# @example Configure an API and define a resource
#   Jeckle.configure do |config|
#     config.register :dribbble do |api|
#       api.base_uri = 'http://api.dribbble.com'
#       api.middlewares do
#         response :json
#       end
#     end
#   end
#
#   class Shot < Jeckle::Resource
#     api :dribbble
#     attribute :id, Jeckle::Types::Integer
#     attribute :name, Jeckle::Types::String
#   end
#
#   Shot.find(1600459)
#   Shot.list(name: 'avengers')
#
module Jeckle
  # Configure APIs to be used on Jeckle::Resources.
  #
  # @yield [Jeckle::Setup] the setup class for registering APIs
  # @see Jeckle::Setup.register
  def self.configure
    yield Jeckle::Setup
  end
end
