# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Middleware::LogRedactor do
  describe '#redact_headers' do
    it 'redacts default sensitive headers' do
      redactor = described_class.new
      headers = {
        'Authorization' => 'Bearer secret-token',
        'X-Api-Key' => 'my-key',
        'Content-Type' => 'application/json'
      }

      result = redactor.redact_headers(headers)

      expect(result['Authorization']).to eq '[REDACTED]'
      expect(result['X-Api-Key']).to eq '[REDACTED]'
      expect(result['Content-Type']).to eq 'application/json'
    end

    it 'redacts custom headers' do
      redactor = described_class.new(headers: %w[X-Secret])
      headers = { 'X-Secret' => 'value', 'Authorization' => 'Bearer token' }

      result = redactor.redact_headers(headers)

      expect(result['X-Secret']).to eq '[REDACTED]'
      expect(result['Authorization']).to eq 'Bearer token'
    end

    it 'redacts headers matching patterns' do
      redactor = described_class.new(headers: [], patterns: [/password/i])
      headers = { 'X-Password-Hash' => 'abc123', 'Content-Type' => 'text/plain' }

      result = redactor.redact_headers(headers)

      expect(result['X-Password-Hash']).to eq '[REDACTED]'
      expect(result['Content-Type']).to eq 'text/plain'
    end

    it 'handles nil headers' do
      redactor = described_class.new
      expect(redactor.redact_headers(nil)).to eq({})
    end
  end
end
