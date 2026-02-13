# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::Create do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '.create' do
    let(:attrs) { { id: 2001 } }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: attrs) }

    it 'calls default API connection with POST' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources', { method: :post, body: attrs }).and_return(fake_request)

      FakeResource.create attrs
    end

    it 'returns an instance of resource' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      result = FakeResource.create(attrs)
      expect(result).to be_an_instance_of(FakeResource)
      expect(result.id).to eq 2001
    end
  end
end
