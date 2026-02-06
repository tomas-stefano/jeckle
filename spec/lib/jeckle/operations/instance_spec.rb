# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::Instance do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '#save' do
    context 'when resource has an id' do
      let(:resource) { FakeResource.new(id: 42) }
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 42 }) }

      it 'sends a PATCH request' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources/42', { method: :patch, body: { id: 42 } })
          .and_return(fake_request)

        result = resource.save
        expect(result).to be_an_instance_of(FakeResource)
        expect(result.id).to eq 42
      end
    end

    context 'when resource has no id' do
      let(:resource) { FakeResource.new }
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 99 }) }

      it 'sends a POST request' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', { method: :post, body: {} })
          .and_return(fake_request)

        result = resource.save
        expect(result).to be_an_instance_of(FakeResource)
        expect(result.id).to eq 99
      end
    end
  end

  describe '#delete' do
    let(:resource) { FakeResource.new(id: 42) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

    it 'sends a DELETE request' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/42', { method: :delete })
        .and_return(fake_request)

      expect(resource.delete).to be true
    end
  end

  describe '#reload' do
    let(:resource) { FakeResource.new(id: 42) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 42 }) }

    it 'sends a GET request and returns a new instance' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/42', {})
        .and_return(fake_request)

      result = resource.reload
      expect(result).to be_an_instance_of(FakeResource)
      expect(result.id).to eq 42
    end
  end
end
