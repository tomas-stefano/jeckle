module Jeckle
  module Resource
    def self.included(base)
      base.send :include, Jeckle::Model
      base.send :include, ActiveModel::Naming

      base.send :extend, Jeckle::Resource::ClassMethods
    end

    module ClassMethods
      def resource_name
        model_name.plural
      end
    end
  end
end
