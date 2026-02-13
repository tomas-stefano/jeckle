# frozen_string_literal: true

module Jeckle
  module Middleware
    # Faraday response middleware that raises Jeckle errors for HTTP error
    # status codes (>= 400). Opt-in via `response :jeckle_raise_error`.
    #
    # @example
    #   api.middlewares do
    #     response :json
    #     response :jeckle_raise_error
    #   end
    class RaiseError < Faraday::Middleware
      # @return [Hash{Integer => Class}] maps HTTP status codes to error classes
      STATUS_MAP = {
        400 => Jeckle::BadRequestError,
        401 => Jeckle::UnauthorizedError,
        403 => Jeckle::ForbiddenError,
        404 => Jeckle::NotFoundError,
        422 => Jeckle::UnprocessableEntityError,
        429 => Jeckle::TooManyRequestsError,
        500 => Jeckle::InternalServerError,
        503 => Jeckle::ServiceUnavailableError
      }.freeze

      # Header names checked for request ID (case-insensitive via Faraday headers).
      REQUEST_ID_HEADERS = %w[X-Request-Id X-Request-ID].freeze

      # @param env [Faraday::Env] the response environment
      # @raise [Jeckle::HTTPError] for status >= 400
      def on_complete(env)
        status = env.status

        return if status < 400

        error_class = STATUS_MAP.fetch(status) do
          status < 500 ? Jeckle::ClientError : Jeckle::ServerError
        end

        request_id = extract_request_id(env.response_headers)

        error_kwargs = { status: status, body: env.body, request_id: request_id }

        if error_class == Jeckle::TooManyRequestsError
          error_kwargs[:rate_limit] = Jeckle::RateLimit.from_headers(env.response_headers)
        end

        raise error_class.new(env.reason_phrase, **error_kwargs)
      end

      private

      def extract_request_id(headers)
        return unless headers

        REQUEST_ID_HEADERS.each do |header|
          value = headers[header]
          return value if value
        end

        nil
      end
    end
  end
end

Faraday::Response.register_middleware(jeckle_raise_error: Jeckle::Middleware::RaiseError)
