module Jeckle
  module Model
    def self.included(base)
      base.send :include, ActiveModel::Validations

      base.send :include, Virtus.model
    end
  end
end
