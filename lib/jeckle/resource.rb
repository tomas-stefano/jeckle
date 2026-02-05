# frozen_string_literal: true

module Jeckle
  module Resource
    def self.included(base)
      base.include ActiveModel::Naming

      base.include Jeckle::Model
      base.include Jeckle::HTTP
      base.include Jeckle::RESTActions

      base.extend Jeckle::AttributeAliasing
    end
  end
end
