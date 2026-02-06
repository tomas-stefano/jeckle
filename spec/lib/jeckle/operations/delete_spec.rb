# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::Delete do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '.destroy' do
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

    it 'calls default API connection with DELETE' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/1001', { method: :delete }).and_return(fake_request)

      FakeResource.destroy 1001
    end

    it 'returns true' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      expect(FakeResource.destroy(1001)).to be true
    end
  end
end
