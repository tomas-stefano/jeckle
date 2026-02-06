# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::ResponseInspector do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '#_response' do
    let(:faraday_response) { OpenStruct.new(body: { id: 42 }, status: 200, headers: { 'X-Request-Id' => 'abc' }) }
    let(:fake_request) { OpenStruct.new(response: faraday_response) }

    it 'stores the raw response on find' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      resource = FakeResource.find(42)
      expect(resource._response).to eq faraday_response
      expect(resource._response.status).to eq 200
    end

    it 'defaults to nil for new instances' do
      resource = FakeResource.new(id: 1)
      expect(resource._response).to be_nil
    end
  end
end
