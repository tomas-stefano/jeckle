# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Auth::OAuth2 do
  subject(:oauth) do
    described_class.new(
      client_id: 'my-id',
      client_secret: 'my-secret',
      token_url: 'https://auth.example.com/oauth/token'
    )
  end

  describe '#expired?' do
    it 'is expired when no token exists' do
      expect(oauth).to be_expired
    end
  end

  describe '#refresh!' do
    let(:response_body) { '{"access_token":"abc123","expires_in":3600}' }
    let(:faraday_response) { OpenStruct.new(body: response_body) }

    before do
      allow(Faraday).to receive(:post).and_return(faraday_response)
    end

    it 'fetches a new access token' do
      oauth.refresh!
      expect(oauth.access_token).to eq 'abc123'
    end

    it 'sends client credentials' do
      expect(Faraday).to receive(:post).with('https://auth.example.com/oauth/token') do |&block|
        req = OpenStruct.new(body: nil, headers: {})
        block.call(req)
        expect(req.body).to include(grant_type: 'client_credentials', client_id: 'my-id')
        faraday_response
      end

      oauth.refresh!
    end
  end

  describe '#token' do
    let(:response_body) { '{"access_token":"xyz","expires_in":3600}' }
    let(:faraday_response) { OpenStruct.new(body: response_body) }

    before do
      allow(Faraday).to receive(:post).and_return(faraday_response)
    end

    it 'returns the access token, refreshing if needed' do
      expect(oauth.token).to eq 'xyz'
    end
  end
end
