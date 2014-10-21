module Jeckle
  module Resource
    def self.included(base)
      base.send :include, ActiveModel::Naming

      base.send :include, Jeckle::Model
      base.send :include, Jeckle::HTTP
      base.send :include, Jeckle::RESTActions
    end
  end
end
