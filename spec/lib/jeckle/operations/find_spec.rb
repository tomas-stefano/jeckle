# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::Find do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '.find' do
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 1001 }) }

    it 'calls default API connection with GET' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/1001', {}).and_return(fake_request)

      FakeResource.find 1001
    end

    it 'returns an instance of resource' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      expect(FakeResource.find(1001)).to be_an_instance_of(FakeResource)
    end
  end
end
