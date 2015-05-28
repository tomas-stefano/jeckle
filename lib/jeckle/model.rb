module Jeckle
  module Model
    def self.included(base)
      base.include ActiveModel::Validations
      base.include Virtus.model
    end
  end
end
