module Jeckle
  module Resource
    def self.included(base)
      base.extend ClassMethods

      base.send :include, Virtus.model
      base.send :include, ActiveModel::Naming
      base.send :include, ActiveModel::Validations
    end

    module ClassMethods
      def resource_name
        model_name.element
      end
    end
  end
end
