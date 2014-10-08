module Jeckle
  class API
    attr_accessor :logger
    attr_writer :base_uri, :namespaces, :params, :headers
    attr_reader :basic_auth

    def connection
      @connection ||= Faraday.new(url: base_uri).tap do |conn|
        conn.headers = headers
        conn.params = params
        conn.response :logger, logger

        conn.basic_auth basic_auth[:username], basic_auth[:password] if basic_auth
        conn.instance_exec &@middlewares_block if @middlewares_block
      end
    end

    def basic_auth=(credential_params)
      [:username, :password].all? do |key|
        credential_params.has_key? key
      end or raise Jeckle::NoUsernameOrPasswordError, credential_params

      @basic_auth = credential_params
    end

    def base_uri
      [@base_uri, *namespaces.values].join '/'
    end

    def params
      @params || {}
    end

    def headers
      @headers || {}
    end

    def namespaces
      @namespaces || {}
    end

    def middlewares(&block)
      raise ArgumentError, 'no block given' unless block_given?

      @middlewares_block = block
    end
  end
end
