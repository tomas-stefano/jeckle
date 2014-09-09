module Jeckle
  class API
    attr_accessor :logger, :namespaces
    attr_writer :base_uri, :params, :headers
    attr_reader :basic_auth

    def connection
      @connection ||= Faraday.new(url: base_uri).tap do |conn|
        conn.headers = headers
        conn.params = params
        conn.basic_auth basic_auth[:username], basic_auth[:password] if basic_auth

        conn.response :logger, logger

        # OPTIMIZE: Make those middleware optional and extensible
        conn.request :json
        conn.response :json
        conn.response :raise_error
      end
    end

    def basic_auth=(credential_params)
      [:username, :password].all? do |key|
        credential_params.has_key? key
      end or raise Jeckle::NoUsernameOrPasswordError, credential_params

      @basic_auth = credential_params
    end

    def base_uri
      suffix = "/#{namespaces.values.join('/')}" if namespaces

      "#{@base_uri}#{suffix}"
    end

    def params
      @params || {}
    end

    def headers
      @headers || {}
    end
  end
end
