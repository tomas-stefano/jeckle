module Jeckle
  class Setup
    def self.register(name)
      Jeckle::API.new.tap do |user_api|
        yield user_api
        registered_apis[name] = user_api
      end
    end

    def self.registered_apis
      @registered_apis ||= {}
    end
  end
end
