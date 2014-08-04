module Jeckle
  class Setup
    def self.register(name)
      user_api = Jeckle::API.new
      yield user_api
      registered_apis[name] = user_api

      user_api
    end

    def self.registered_apis
      @registered_apis ||= {}
    end
  end
end