require 'spec_helper'

RSpec.describe Jeckle::API do
  subject(:jeckle_api) { Jeckle::Setup.registered_apis[:my_super_api] }

  describe '#connection' do
    before { jeckle_api.instance_variable_set(:@connection, nil) }

    let(:fake_faraday_connection) { Faraday::Connection.new }

    it 'returns a Faraday connection' do
      expect(jeckle_api.connection).to be_kind_of Faraday::Connection
    end

    it 'caches the connection' do
      expect(Faraday).to receive(:new).once.and_return(fake_faraday_connection).with(url: jeckle_api.base_uri)
      expect(fake_faraday_connection).to receive(:tap).once.and_call_original

      10.times { jeckle_api.connection }
    end

    it 'assigns api_headers' do
      expect(jeckle_api.connection.headers).to include 'Content-Type' => 'application/json'
    end

    it 'assigns basic auth headers' do
      expect(jeckle_api.connection.headers.keys).to include 'Authorization'
    end

    it 'assigns params there will be used on all requests' do
      expect(jeckle_api.connection.params).to eq 'hello' => 'world'
    end

    context 'when middlewares_block is set' do
      before do
        jeckle_api.middlewares do
          request :retry, max: 2, interval: 0.05
          request :instrumentation
        end
      end

      it 'adds middlewares on connection middleware stack' do
        expect(jeckle_api.connection.builder.handlers.last(2)).to eq [
          Faraday::Request::Retry,
          Faraday::Request::Instrumentation
        ]
      end
    end
  end

  describe '#base_uri' do
    context 'when namespaces are defined' do
      it 'appends namespaces' do
        expect(jeckle_api.base_uri).to eq 'http://my-super-api.com.br/api/v1'
      end
    end

    context 'when no namespaces are defined' do
      subject(:jeckle_api) { described_class.new }

      before { jeckle_api.base_uri = 'http://my-super-api.com.br' }

      it 'keeps base_uri without adding namespaces or futher slashes' do
        expect(jeckle_api.base_uri).to eq 'http://my-super-api.com.br'
      end
    end
  end

  describe '#basic_auth=' do
    subject(:jeckle_api) { described_class.new }

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
        expect { jeckle_api.basic_auth = credentials }.to raise_error Jeckle::NoUsernameOrPasswordError
      end
    end
  end

  describe '#params' do
    context 'when there are params' do
      it 'assigns params hash' do
        expect(jeckle_api.params).to eq hello: 'world'
      end
    end

    context 'when there are no params' do
      subject(:jeckle_api) { described_class.new }

      it 'assigns an empty hash' do
        expect(jeckle_api.params).to eq({})
      end
    end
  end

  describe '#headers' do
    context 'when there are headers' do
      it 'assigns headers hash' do
        expect(jeckle_api.headers).to eq 'Content-Type' => 'application/json'
      end
    end

    context 'when there are no headers' do
      subject(:jeckle_api) { described_class.new }

      it 'assigns an empty hash' do
        expect(jeckle_api.headers).to eq({})
      end
    end
  end

  describe '#middlewares' do
    context 'when a block is given' do
      it 'assigns middleware_block' do
        jeckle_api.middlewares { 123 }

        expect(jeckle_api.instance_variable_get('@middlewares_block')).not_to be_nil
      end
    end

    context 'when no block is given' do
      it 'raises error' do
        expect {
          jeckle_api.middlewares
        }.to raise_error ArgumentError, /no block given/
      end
    end
  end
end
