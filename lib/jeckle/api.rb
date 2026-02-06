# frozen_string_literal: true

module Jeckle
  # Holds configuration for a single API endpoint including base URI,
  # authentication, headers, params, timeouts, and Faraday middlewares.
  class API
    # @return [Logger, nil] logger for request/response logging
    attr_accessor :logger

    # @!attribute [w] base_uri
    #   @param value [String] the base URL for the API
    # @!attribute [w] namespaces
    #   @param value [Hash] URL path segments appended to base_uri
    # @!attribute [w] params
    #   @param value [Hash] default query parameters for all requests
    # @!attribute [w] headers
    #   @param value [Hash] default headers for all requests
    # @!attribute [w] open_timeout
    #   @param value [Integer] connection open timeout in seconds
    # @!attribute [w] read_timeout
    #   @param value [Integer] read timeout in seconds
    attr_writer :base_uri, :namespaces, :params, :headers, :open_timeout, :read_timeout

    # @return [Hash, nil] basic auth credentials
    # @return [Integer, nil] request timeout
    # @return [String, nil] bearer token for Authorization header
    # @return [Hash, nil] API key configuration
    # @return [Hash, nil] retry configuration for faraday-retry
    # @return [#paginate, #next_context, nil] pagination strategy for collections
    attr_reader :basic_auth, :request_timeout, :bearer_token, :api_key, :retry_options,
                :pagination_strategy

    # Returns or builds a configured Faraday connection.
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url: base_uri, request: timeout).tap do |conn|
        conn.headers = headers
        conn.params = params
        conn.response :logger, logger

        conn.request :authorization, :basic, basic_auth[:username], basic_auth[:password] if basic_auth
        conn.request :authorization, :Bearer, bearer_token if bearer_token
        conn.request :retry, retry_options if retry_options

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

    # Set basic authentication credentials.
    #
    # @param credential_params [Hash] must contain :username and :password
    # @raise [Jeckle::NoUsernameOrPasswordError] if keys are missing
    # @return [Hash]
    def basic_auth=(credential_params)
      %i[username password].all? do |key|
        credential_params.key? key
      end or raise Jeckle::NoUsernameOrPasswordError, credential_params

      @basic_auth = credential_params
    end

    # Set bearer token authentication. Resets cached connection.
    #
    # @param token [String] the bearer token
    # @return [String]
    def bearer_token=(token)
      @connection = nil
      @bearer_token = token
    end

    # Configure automatic retries using faraday-retry. Resets cached connection.
    #
    # @param options [Hash] retry options passed to Faraday::Retry::Middleware
    # @option options [Integer] :max (2) maximum number of retries
    # @option options [Float] :interval (0.5) initial interval between retries in seconds
    # @option options [Float] :interval_randomness (0.5) randomness factor for retry interval
    # @option options [Integer] :backoff_factor (2) exponential backoff multiplier
    # @option options [Array<Integer>] :retry_statuses ([429, 500, 502, 503]) HTTP status codes to retry
    # @return [Hash]
    #
    # @example
    #   api.retry = { max: 3, interval: 1, retry_statuses: [429, 503] }
    def retry=(options)
      @connection = nil
      @retry_options = DEFAULT_RETRY_OPTIONS.merge(options)
    end

    # Default retry configuration.
    DEFAULT_RETRY_OPTIONS = {
      max: 2,
      interval: 0.5,
      interval_randomness: 0.5,
      backoff_factor: 2,
      retry_statuses: [429, 500, 502, 503]
    }.freeze

    # Set API key authentication. Resets cached connection.
    #
    # @param config [Hash] must contain :value and either :header or :param
    # @raise [Jeckle::ArgumentError] if config is invalid
    # @return [Hash]
    #
    # @example Header-based API key
    #   api.api_key = { value: 'secret', header: 'X-Api-Key' }
    #
    # @example Query param-based API key
    #   api.api_key = { value: 'secret', param: 'api_key' }
    def api_key=(config)
      unless config.is_a?(Hash) && config[:value] && (config[:header] || config[:param])
        raise Jeckle::ArgumentError, 'api_key requires :value and either :header or :param'
      end

      @connection = nil
      @api_key = config
    end

    # Returns the full base URI including namespace segments.
    #
    # @return [String]
    def base_uri
      [@base_uri, *namespaces.values].join '/'
    end

    # @return [Hash] default query parameters
    def params
      @params || {}
    end

    # @return [Hash] default headers
    def headers
      @headers || {}
    end

    # @return [Hash] URL namespace segments
    def namespaces
      @namespaces || {}
    end

    # Configure the pagination strategy for this API.
    #
    # @param strategy [Symbol, #paginate] :offset, :cursor, :link_header, or a strategy instance
    # @param options [Hash] options passed to the built-in strategy constructor
    # @return [#paginate, #next_context]
    #
    # @example Cursor-based pagination (Stripe-style)
    #   api.pagination :cursor, cursor_param: :starting_after, limit_param: :limit
    #
    # @example Link header pagination (GitHub-style)
    #   api.pagination :link_header
    #
    # @example Custom strategy instance
    #   api.pagination MyCustomStrategy.new
    def pagination(strategy, **options)
      @pagination_strategy = case strategy
                             when :offset then Jeckle::Pagination::Offset.new(**options)
                             when :cursor then Jeckle::Pagination::Cursor.new(**options)
                             when :link_header then Jeckle::Pagination::LinkHeader.new(**options)
                             else strategy
                             end
    end

    # Configure Faraday middlewares for this API.
    #
    # @yield block evaluated in the context of the Faraday connection builder
    # @raise [Jeckle::ArgumentError] if no block is given
    #
    # @example
    #   api.middlewares do
    #     request :json
    #     response :json
    #     response :jeckle_raise_error
    #   end
    def middlewares(&block)
      raise Jeckle::ArgumentError, 'A block is required when configuring API middlewares' unless block_given?

      @middlewares_block = block
    end

    # Returns timeout configuration hash for Faraday.
    #
    # @return [Hash]
    def timeout
      {}.tap do |t|
        t[:open_timeout] = @open_timeout if @open_timeout
        t[:timeout] = @read_timeout if @read_timeout
      end
    end
  end
end
