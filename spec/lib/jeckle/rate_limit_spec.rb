# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::RateLimit do
  describe '.from_headers' do
    it 'parses X-RateLimit headers' do
      headers = {
        'X-RateLimit-Limit' => '5000',
        'X-RateLimit-Remaining' => '4999',
        'X-RateLimit-Reset' => '1704067200'
      }

      rate_limit = described_class.from_headers(headers)

      expect(rate_limit.limit).to eq 5000
      expect(rate_limit.remaining).to eq 4999
      expect(rate_limit.reset_at).to eq Time.at(1_704_067_200)
    end

    it 'parses RateLimit headers (no X- prefix)' do
      headers = {
        'RateLimit-Limit' => '100',
        'RateLimit-Remaining' => '50'
      }

      rate_limit = described_class.from_headers(headers)

      expect(rate_limit.limit).to eq 100
      expect(rate_limit.remaining).to eq 50
      expect(rate_limit.reset_at).to be_nil
    end

    it 'returns nil when no rate limit headers present' do
      expect(described_class.from_headers({})).to be_nil
    end

    it 'returns nil when headers is nil' do
      expect(described_class.from_headers(nil)).to be_nil
    end
  end
end
