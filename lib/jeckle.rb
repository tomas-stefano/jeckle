# frozen_string_literal: true

require 'active_model'
require 'dry-struct'
require 'dry/types'
require 'faraday'

require 'jeckle/version'

%w[
  types setup api model request http rest_actions attribute_aliasing resource errors
  middleware/raise_error
].each do |file_name|
  require "jeckle/#{file_name}"
end

module Jeckle
  # Configure APIs to be used on Jeckle::Resources.
  # See Jeckle::Setup for more information.
  #
  def self.configure
    yield Jeckle::Setup
  end
end
