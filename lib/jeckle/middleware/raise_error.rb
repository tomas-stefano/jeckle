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

      # @param env [Faraday::Env] the response environment
      # @raise [Jeckle::HTTPError] for status >= 400
      def on_complete(env)
        status = env.status

        return if status < 400

        error_class = STATUS_MAP.fetch(status) do
          status < 500 ? Jeckle::ClientError : Jeckle::ServerError
        end

        raise error_class.new(env.reason_phrase, status: status, body: env.body)
      end
    end
  end
end

Faraday::Response.register_middleware(jeckle_raise_error: Jeckle::Middleware::RaiseError)
