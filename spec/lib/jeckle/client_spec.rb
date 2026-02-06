# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Client do
  describe '#initialize' do
    it 'creates a client from a registered API' do
      client = described_class.new(:my_super_api)
      expect(client.api).to be_a Jeckle::API
    end

    it 'raises NoSuchAPIError for unregistered API' do
      expect { described_class.new(:nonexistent) }.to raise_error Jeckle::NoSuchAPIError
    end

    it 'overrides bearer_token' do
      client = described_class.new(:my_super_api, bearer_token: 'custom-token')
      expect(client.api.bearer_token).to eq 'custom-token'
    end
  end

  describe '#find' do
    let(:client) { described_class.new(:my_super_api) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 42 }) }

    it 'fetches a resource' do
      expect(Jeckle::Request).to receive(:run)
        .with(client.api, 'fake_resources/42', {})
        .and_return(fake_request)

      result = client.find(FakeResource, 42)
      expect(result).to be_an_instance_of(FakeResource)
      expect(result.id).to eq 42
    end
  end

  describe '#list' do
    let(:client) { described_class.new(:my_super_api) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }, { id: 2 }]) }

    it 'fetches a collection' do
      expect(Jeckle::Request).to receive(:run)
        .with(client.api, 'fake_resources', { params: { name: 'test' } })
        .and_return(fake_request)

      results = client.list(FakeResource, name: 'test')
      expect(results.size).to eq 2
      expect(results).to all(be_an_instance_of(FakeResource))
    end
  end

  describe '#create' do
    let(:client) { described_class.new(:my_super_api) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 99 }) }

    it 'creates a resource' do
      expect(Jeckle::Request).to receive(:run)
        .with(client.api, 'fake_resources', { method: :post, body: { id: 99 } })
        .and_return(fake_request)

      result = client.create(FakeResource, id: 99)
      expect(result).to be_an_instance_of(FakeResource)
    end
  end

  describe '#destroy' do
    let(:client) { described_class.new(:my_super_api) }
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

    it 'deletes a resource' do
      expect(Jeckle::Request).to receive(:run)
        .with(client.api, 'fake_resources/42', { method: :delete })
        .and_return(fake_request)

      expect(client.destroy(FakeResource, 42)).to be true
    end
  end
end
