# frozen_string_literal: true

module Jeckle
  # Base error class for all Jeckle errors.
  class Error < StandardError; end

  # Raised when a network connection cannot be established.
  class ConnectionError < Error; end

  # Raised when a request exceeds the configured timeout.
  class TimeoutError < Error; end

  # Base class for HTTP error responses (status >= 400).
  #
  # @example
  #   begin
  #     Shot.find(999)
  #   rescue Jeckle::HTTPError => e
  #     puts e.status #=> 404
  #     puts e.body   #=> '{"error":"not found"}'
  #   end
  class HTTPError < Error
    # @return [Integer, nil] the HTTP status code
    attr_reader :status

    # @return [String, nil] the response body
    attr_reader :body

    # @return [String, nil] the request ID from X-Request-Id response header
    attr_reader :request_id

    # @param message [String, nil] error message
    # @param status [Integer, nil] HTTP status code
    # @param body [String, nil] response body
    # @param request_id [String, nil] request ID from response headers
    def initialize(message = nil, status: nil, body: nil, request_id: nil)
      @status = status
      @body = body
      @request_id = request_id
      super(message)
    end
  end

  # Base class for 4xx client errors.
  class ClientError < HTTPError; end

  # HTTP 400 Bad Request.
  class BadRequestError < ClientError
    DEFAULT_STATUS = 400

    def initialize(message = 'Bad Request', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 401 Unauthorized.
  class UnauthorizedError < ClientError
    DEFAULT_STATUS = 401

    def initialize(message = 'Unauthorized', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 403 Forbidden.
  class ForbiddenError < ClientError
    DEFAULT_STATUS = 403

    def initialize(message = 'Forbidden', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 404 Not Found.
  class NotFoundError < ClientError
    DEFAULT_STATUS = 404

    def initialize(message = 'Not Found', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 422 Unprocessable Entity.
  class UnprocessableEntityError < ClientError
    DEFAULT_STATUS = 422

    def initialize(message = 'Unprocessable Entity', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 429 Too Many Requests.
  class TooManyRequestsError < ClientError
    DEFAULT_STATUS = 429

    def initialize(message = 'Too Many Requests', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # Base class for 5xx server errors.
  class ServerError < HTTPError; end

  # HTTP 500 Internal Server Error.
  class InternalServerError < ServerError
    DEFAULT_STATUS = 500

    def initialize(message = 'Internal Server Error', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # HTTP 503 Service Unavailable.
  class ServiceUnavailableError < ServerError
    DEFAULT_STATUS = 503

    def initialize(message = 'Service Unavailable', status: DEFAULT_STATUS, body: nil, request_id: nil)
      super
    end
  end

  # Jeckle-specific argument error.
  class ArgumentError < ::ArgumentError; end

  # Raised when a referenced API name is not registered.
  class NoSuchAPIError < ArgumentError
    # @param api [Symbol] the unregistered API name
    def initialize(api)
      message = %(The API name '#{api}' doesn't exist in Jeckle definitions.

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to put the right API name!
        Heckle: - Hey pal, tell me the APIs then!
        Jeckle: - Deal the trays, old thing: #{Jeckle::Setup.registered_apis.keys}.
      )

      super(message)
    end
  end

  # Raised when basic_auth is missing username or password.
  class NoUsernameOrPasswordError < ArgumentError
    # @param _credentials [Hash] the invalid credentials hash
    def initialize(_credentials)
      message = %(No such keys "username" and "password" on `basic_auth` definition"

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to define a username and a password for basic auth!
      )

      super(message)
    end
  end
end
