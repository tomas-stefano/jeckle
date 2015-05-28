require_relative 'resource/action_dsl'

module Jeckle
  module Resource
    def self.included(base)
      base.include ActiveModel::Naming

      base.include Jeckle::Model
      base.include Jeckle::HTTP
      base.include Jeckle::RESTActions

      base.extend Jeckle::Resource::ActionDSL
      base.extend Jeckle::AttributeAliasing
    end
  end
end
