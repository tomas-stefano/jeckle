# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::RESTActions do
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

  describe '.list' do
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: body) }

    let(:query) { { name: 'cocada' } }

    context 'when there are results WITHOUT root node' do
      let(:body) { [{ id: 1001 }, { id: 1002 }] }

      it 'calls default API connection with GET and list params' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', { params: query }).and_return(fake_request)

        FakeResource.list query
      end

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.list(query)).to match [
          an_instance_of(FakeResource),
          an_instance_of(FakeResource)
        ]
      end
    end

    context 'when there are results WITH root node' do
      let(:body) do
        { 'fake_resources' => [{ id: 1001 }, { id: 1002 }] }
      end

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.list(query)).to match [
          an_instance_of(FakeResource),
          an_instance_of(FakeResource)
        ]
      end
    end

    context 'when there are no results' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

      it 'returns an empty Array' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.list(query)).to match []
      end
    end

    context 'when the endpoint is overwritten' do
      let(:endpoint) { 'custom_endpoint' }
      let(:query) { { resource_name: endpoint, name: 'cocada' } }
      let(:body) { [{ id: 1001 }, { id: 1002 }] }

      it 'calls default API connection with GET and list params' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, endpoint, { params: query }).and_return(fake_request)

        FakeResource.list query
      end
    end
  end

  describe '.search' do
    it 'delegates to list with a deprecation warning' do
      allow(Jeckle::Request).to receive(:run)
        .and_return(OpenStruct.new(response: OpenStruct.new(body: [])))

      expect { FakeResource.search(name: 'test') }
        .to output(/DEPRECATION.*search.*list/).to_stderr
    end
  end
end
