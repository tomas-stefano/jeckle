# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Operations::List do
  let(:api) { FakeResource.api_mapping[:default_api] }

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
