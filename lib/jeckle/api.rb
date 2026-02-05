# frozen_string_literal: true

module Jeckle
  class API
    attr_accessor :logger
    attr_writer :base_uri, :namespaces, :params, :headers, :open_timeout, :read_timeout
    attr_reader :basic_auth, :request_timeout, :bearer_token, :api_key

    def connection
      @connection ||= Faraday.new(url: base_uri, request: timeout).tap do |conn|
        conn.headers = headers
        conn.params = params
        conn.response :logger, logger

        conn.request :authorization, :basic, basic_auth[:username], basic_auth[:password] if basic_auth
        conn.request :authorization, :Bearer, bearer_token if bearer_token

        if api_key
          if api_key[:header]
            conn.headers[api_key[:header]] = api_key[:value]
          elsif api_key[:param]
            conn.params[api_key[:param]] = api_key[:value]
          end
        end

        conn.instance_exec(&@middlewares_block) if @middlewares_block
      end
    end

    def basic_auth=(credential_params)
      %i[username password].all? do |key|
        credential_params.key? key
      end or raise Jeckle::NoUsernameOrPasswordError, credential_params

      @basic_auth = credential_params
    end

    def bearer_token=(token)
      @connection = nil
      @bearer_token = token
    end

    def api_key=(config)
      unless config.is_a?(Hash) && config[:value] && (config[:header] || config[:param])
        raise Jeckle::ArgumentError, 'api_key requires :value and either :header or :param'
      end

      @connection = nil
      @api_key = config
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
      raise Jeckle::ArgumentError, 'A block is required when configuring API middlewares' unless block_given?

      @middlewares_block = block
    end

    def timeout
      {}.tap do |t|
        t[:open_timeout] = @open_timeout if @open_timeout
        t[:timeout] = @read_timeout if @read_timeout
      end
    end
  end
end
