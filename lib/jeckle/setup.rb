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

  class Jeckle::Setup::NoSuchAPIError < ArgumentError
    def message(*args)
      "No such API '#{super}'"
    end
  end
end
