# frozen_string_literal: true

module Jeckle
  # Tracks rate limit information from API response headers.
  #
  # @example
  #   rate_limit = Jeckle::RateLimit.from_headers(response.headers)
  #   rate_limit.remaining #=> 4999
  #   rate_limit.reset_at  #=> 2024-01-01 12:00:00 +0000
  class RateLimit
    # @return [Integer, nil] maximum requests allowed in the window
    attr_reader :limit

    # @return [Integer, nil] remaining requests in the current window
    attr_reader :remaining

    # @return [Time, nil] when the rate limit window resets
    attr_reader :reset_at

    # @param limit [Integer, nil] maximum requests
    # @param remaining [Integer, nil] remaining requests
    # @param reset_at [Time, nil] reset timestamp
    def initialize(limit: nil, remaining: nil, reset_at: nil)
      @limit = limit
      @remaining = remaining
      @reset_at = reset_at
    end

    # Build a RateLimit from response headers.
    # Supports common header patterns (X-RateLimit-*, RateLimit-*).
    #
    # @param headers [Hash] response headers
    # @return [Jeckle::RateLimit, nil] nil if no rate limit headers found
    def self.from_headers(headers)
      return nil unless headers

      limit = extract_int(headers, 'X-RateLimit-Limit', 'RateLimit-Limit')
      remaining = extract_int(headers, 'X-RateLimit-Remaining', 'RateLimit-Remaining')
      reset = extract_reset(headers)

      return nil unless limit || remaining || reset

      new(limit: limit, remaining: remaining, reset_at: reset)
    end

    class << self
      private

      def extract_int(headers, *keys)
        keys.each do |key|
          value = headers[key]
          return value.to_i if value
        end
        nil
      end

      def extract_reset(headers)
        value = headers['X-RateLimit-Reset'] || headers['RateLimit-Reset']
        return nil unless value

        Time.at(value.to_i)
      end
    end
  end
end
