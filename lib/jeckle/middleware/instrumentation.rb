# frozen_string_literal: true

module Jeckle
  module Middleware
    # Faraday middleware that emits ActiveSupport::Notifications events
    # for every HTTP request, enabling observability and metrics collection.
    #
    # @example Enable in API configuration
    #   api.middlewares do
    #     request :jeckle_instrumentation
    #   end
    #
    # @example Subscribe to events
    #   ActiveSupport::Notifications.subscribe('request.jeckle') do |*args|
    #     event = ActiveSupport::Notifications::Event.new(*args)
    #     puts "#{event.payload[:method]} #{event.payload[:url]} => #{event.payload[:status]}"
    #   end
    class Instrumentation < Faraday::Middleware
      def call(env)
        if defined?(ActiveSupport::Notifications)
          ActiveSupport::Notifications.instrument('request.jeckle', request_payload(env)) do |payload|
            @app.call(env).on_complete do |response_env|
              payload[:status] = response_env.status
              payload[:response_headers] = response_env.response_headers
            end
          end
        else
          @app.call(env)
        end
      end

      private

      def request_payload(env)
        {
          method: env.method,
          url: env.url.to_s,
          request_headers: env.request_headers
        }
      end
    end
  end
end

Faraday::Request.register_middleware(jeckle_instrumentation: Jeckle::Middleware::Instrumentation)
