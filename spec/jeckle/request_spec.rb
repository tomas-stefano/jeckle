require 'spec_helper'

RSpec.describe Jeckle::Request do
  let(:api) { Jeckle::Setup.registered_apis[:my_super_api] }

  before do
    # Manipulate Faraday internals to avoid real requests
    class FakeRackBuilder; def build_response(conn, req); end; end
    fake_builder = FakeRackBuilder.new

    allow(api.connection).to receive(:builder).and_return(fake_builder)
  end

  describe '.run_request' do
    after { described_class.run_request api, endpoint, options }

    context 'GET' do
      let(:options) { {} }
      let(:endpoint) { 'fake_resource/4' }

      it 'calls GET request on API\'s connection' do
        expect(api.connection).to receive(:get).and_call_original

        expect_any_instance_of(Faraday::Request).to receive(:url).with endpoint

        # Global connection params defined via register block
        expect_any_instance_of(Faraday::Request).to receive(:params=).with('hello' => 'world').once

        # Per request params
        expect_any_instance_of(Faraday::Request).to receive(:params=).with(options).once
      end
    end

    context 'POST' do
      let(:endpoint) { 'fake_resources' }
      let(:options) { { body: { value: 1000 }, method: :post } }

      it 'calls POST request on API\'s connection' do
        expect(api.connection).to receive(:post).and_call_original
        expect_any_instance_of(Faraday::Request).to receive(:url).with endpoint

        # Global connection params defined via register block
        expect_any_instance_of(Faraday::Request).to receive(:params=).with('hello' => 'world').once

        # Per request params
        expect_any_instance_of(Faraday::Request).to receive(:params=).with({}).once

        expect_any_instance_of(Faraday::Request).to receive(:body=).with(options[:body]).once
      end
    end

    context 'PUT' do
      let(:endpoint) { 'fake_resources' }
      let(:options) { { body: { id: 1001, value: 1000 }, method: :put } }

      it 'calls PUT request on API\'s connection' do
        expect(api.connection).to receive(:put).and_call_original
        expect_any_instance_of(Faraday::Request).to receive(:url).with endpoint

        # Global connection params defined via register block
        expect_any_instance_of(Faraday::Request).to receive(:params=).with('hello' => 'world').once

        # Per request params
        expect_any_instance_of(Faraday::Request).to receive(:params=).with({}).once

        expect_any_instance_of(Faraday::Request).to receive(:body=).with(options[:body]).once
      end
    end

    context 'DELETE' do
      let(:options) { { method: :delete } }
      let(:endpoint) { 'fake_resource/4' }

      it 'calls DELETE request on API\'s connection' do
        expect(api.connection).to receive(:delete).and_call_original

        expect_any_instance_of(Faraday::Request).to receive(:url).with endpoint

        # Global connection params defined via register block
        expect_any_instance_of(Faraday::Request).to receive(:params=).with('hello' => 'world').once

        # Per request params
        expect_any_instance_of(Faraday::Request).to receive(:params=).with(options).once
      end
    end
  end
end
