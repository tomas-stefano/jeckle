require 'jeckle/version'
require 'active_support/dependencies/autoload'
require 'active_support/concern'
require 'virtus'
require 'active_model'

module Jeckle
  extend ActiveSupport::Autoload

  autoload :Resource
end
