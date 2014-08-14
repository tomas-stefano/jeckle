require 'spec_helper'

RSpec.describe Jeckle::API do
  subject(:jeckle_api) { described_class.new }

  describe '#basic_auth=' do
    context 'when there is the required credentials' do
      let(:credentials) { { username: 'sly', password: 'IAmTheLaw'} }

      before { jeckle_api.basic_auth = credentials }

      it 'assigns creditals hash' do
        expect(jeckle_api.basic_auth).to eq credentials
      end
    end

    context 'when required creadentials is missing' do
      let(:credentials) { {} }

      it 'raises a argument error NoUsernameOrPasswordError' do
        expect { jeckle_api.basic_auth = credentials }.to raise_error Jeckle::API::NoUsernameOrPasswordError
      end
    end
  end

  describe '#connection' do
    subject(:api) { Jeckle::Setup.registered_apis[:my_super_api] }

    before { api.instance_variable_set(:@connection, nil) }

    let(:fake_faraday_connection) { Faraday::Connection.new }

    it 'defines a Faraday connection' do
      expect(api.connection).to be_kind_of Faraday::Connection
    end

    it 'caches the connection' do
      expect(Faraday).to receive(:new).once.and_return(fake_faraday_connection).with(url: 'http://my-super-api.com.br')
      expect(fake_faraday_connection).to receive(:tap).once.and_call_original

      10.times { api.connection }
    end

    it 'assigns api_headers' do
      expect(api.connection.headers).to match 'Content-Type' => 'application/json'
    end
  end
end
