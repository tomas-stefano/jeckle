require 'spec_helper'

RSpec.describe Jeckle do
  subject(:fake_resource) { FakeResource.new }

  it 'defines a response attribute reader' do
    expect(fake_resource).to respond_to :response
  end

  it 'includes active_model/validations' do
    expect(FakeResource.ancestors).to include ActiveModel::Validations
  end

  it 'includes active_model/naming' do
    expect(FakeResource.ancestors).to include ActiveModel::Naming
  end

  describe '.resource_name' do
    it 'returns snake case model name by default' do
      expect(FakeResource.resource_name).to eq 'fake_resource'
    end
  end

  describe '.api' do
    before { FakeResource.instance_variable_set(:@api, nil) }

    let(:fake_faraday_connection) { Faraday::Connection.new }

    it 'defines a Faraday api' do
      expect(FakeResource.api).to be_kind_of Faraday::Connection
    end

    it 'caches the api' do
      expect(Faraday).to receive(:new).once.and_return(fake_faraday_connection).with(url: 'http://myapi.com')
      expect(fake_faraday_connection).to receive(:tap).once.and_call_original

      10.times { FakeResource.api }
    end

    it 'assigns api_headers' do
      expect(FakeResource.api.headers).to match 'Content-Type' => 'application/json'
    end
  end
end
