require_relative 'model/attribute_aliasing'

module Jeckle
  module Model
    def self.included(base)
      base.send :include, ActiveModel::Validations
      base.send :include, Virtus.model

      base.send :extend, Jeckle::Model::AttributeAliasing
    end
  end
end
