module Jeckle
  class API
    attr_accessor :headers, :logger, :namespaces, :params
    attr_writer :base_uri
    attr_reader :basic_auth

    def connection
      @connection ||= Faraday.new(url: base_uri).tap do |conn|
        conn.headers = headers
        conn.basic_auth *credentials unless basic_auth.empty?
      end
    end

    def basic_auth=(credential_params)
      [:username, :password].all? do |key|
        credential_params.has_key? key
      end || raise(NoUsernameOrPasswordError.new credential_params)

      @basic_auth = credential_params
    end

    def base_uri
      sufix = "/#{namespaces.values.join('/')}" if namespaces

      "#{@base_uri}#{sufix}"
    end

    private

    def credentials
      [basic_auth[:username], basic_auth[:password]]
    end
  end

  class API::NoUsernameOrPasswordError < ArgumentError
    def message(*args)
      "No such keys \"username\" and \"password\" on `basic_auth` #{super} definition"
    end
  end
end
