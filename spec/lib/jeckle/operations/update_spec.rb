# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::Update do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '.update' do
    let(:attrs) { { id: 1001 } }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: attrs) }

    it 'calls default API connection with PATCH' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/1001', { method: :patch, body: attrs }).and_return(fake_request)

      FakeResource.update 1001, attrs
    end

    it 'returns an instance of resource' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      result = FakeResource.update(1001, attrs)
      expect(result).to be_an_instance_of(FakeResource)
      expect(result.id).to eq 1001
    end
  end
end
