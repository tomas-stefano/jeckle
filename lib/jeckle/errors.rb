# frozen_string_literal: true

module Jeckle
  class Error < StandardError; end

  class ConnectionError < Error; end
  class TimeoutError < Error; end

  class HTTPError < Error
    attr_reader :status, :body

    def initialize(message = nil, status: nil, body: nil)
      @status = status
      @body = body
      super(message)
    end
  end

  class ClientError < HTTPError; end

  class BadRequestError < ClientError
    DEFAULT_STATUS = 400

    def initialize(message = 'Bad Request', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class UnauthorizedError < ClientError
    DEFAULT_STATUS = 401

    def initialize(message = 'Unauthorized', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class ForbiddenError < ClientError
    DEFAULT_STATUS = 403

    def initialize(message = 'Forbidden', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class NotFoundError < ClientError
    DEFAULT_STATUS = 404

    def initialize(message = 'Not Found', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class UnprocessableEntityError < ClientError
    DEFAULT_STATUS = 422

    def initialize(message = 'Unprocessable Entity', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class TooManyRequestsError < ClientError
    DEFAULT_STATUS = 429

    def initialize(message = 'Too Many Requests', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class ServerError < HTTPError; end

  class InternalServerError < ServerError
    DEFAULT_STATUS = 500

    def initialize(message = 'Internal Server Error', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  class ServiceUnavailableError < ServerError
    DEFAULT_STATUS = 503

    def initialize(message = 'Service Unavailable', status: DEFAULT_STATUS, body: nil)
      super
    end
  end

  # Legacy errors (kept for backwards compatibility)
  class ArgumentError < ::ArgumentError; end

  class NoSuchAPIError < ArgumentError
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

  class NoUsernameOrPasswordError < ArgumentError
    def initialize(_credentials)
      message = %(No such keys "username" and "password" on `basic_auth` definition"

        Heckle: - Hey chum, what we can do now?
        Jeckle: - Old chap, you need to define a username and a password for basic auth!
      )

      super(message)
    end
  end
end
