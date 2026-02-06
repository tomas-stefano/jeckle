# frozen_string_literal: true

module Jeckle
  module Middleware
    # Utility for redacting sensitive data from log output.
    #
    # @example
    #   redactor = LogRedactor.new(headers: %w[Authorization X-Api-Key], patterns: [/password/i])
    #   redactor.redact_headers({ 'Authorization' => 'Bearer secret' })
    #   #=> { 'Authorization' => '[REDACTED]' }
    class LogRedactor
      DEFAULT_HEADERS = %w[Authorization X-Api-Key X-API-Key].freeze

      # @param headers [Array<String>] header names to redact
      # @param patterns [Array<Regexp>] patterns to match header names for redaction
      def initialize(headers: DEFAULT_HEADERS, patterns: [])
        @redact_headers = headers.map(&:downcase)
        @patterns = patterns
      end

      # Redact sensitive values from a headers hash.
      #
      # @param headers [Hash] headers to redact
      # @return [Hash] headers with sensitive values replaced
      def redact_headers(headers)
        return {} unless headers

        headers.each_with_object({}) do |(key, value), result|
          result[key] = should_redact?(key) ? '[REDACTED]' : value
        end
      end

      private

      def should_redact?(key)
        downcased = key.to_s.downcase
        @redact_headers.include?(downcased) || @patterns.any? { |p| downcased.match?(p) }
      end
    end
  end
end
