module Jeckle
  class API
    attr_accessor :base_uri, :headers, :logger
    attr_reader :basic_auth

    def basic_auth=(credentials)
      raise NoUsernameOrPasswordError.new(credentials) unless [:username, :password].all? do |key|
        credentials.has_key? key
      end

      @basic_auth = credentials
    end
  end

  class API::NoUsernameOrPasswordError < ArgumentError
    def message(*args)
      "No such keys \"username\" and \"password\" on `basic_auth` #{super} definition"
    end
  end
end
