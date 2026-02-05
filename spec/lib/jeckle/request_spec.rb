# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Request do
  let(:api) { Jeckle::Setup.registered_apis[:my_super_api] }

  before do
    # Manipulate Faraday internals to avoid real requests
    class FakeRackBuilder; def build_response(conn, req); end; end
    fake_builder = FakeRackBuilder.new

    allow(api.connection).to receive(:builder).and_return(fake_builder)
  end

  describe '.run' do
    before { allow(api.connection).to receive(http_method).and_call_original }

    context 'GET' do
      let(:options) { {} }
      let(:endpoint) { 'fake_resource/4' }
      let(:http_method) { :get }

      it_behaves_like described_class

      it 'calls GET request on API\'s connection' do
        expect(api.connection).to receive(http_method).and_call_original

        described_class.run api, endpoint, options
      end
    end

    context 'POST' do
      let(:endpoint) { 'fake_resources' }
      let(:options) { { body: { value: 1000 }, method: http_method } }
      let(:http_method) { :post }

      it_behaves_like described_class

      it 'calls POST request on API\'s connection' do
        expect(api.connection).to receive(:post).and_call_original

        described_class.run api, endpoint, options
      end
    end

    context 'PUT' do
      let(:endpoint) { 'fake_resources' }
      let(:options) { { body: { id: 1001, value: 1000 }, method: http_method } }
      let(:http_method) { :put }

      it_behaves_like described_class

      it 'calls PUT request on API\'s connection' do
        expect(api.connection).to receive(:put).and_call_original

        described_class.run api, endpoint, options
      end
    end

    context 'PATCH' do
      let(:endpoint) { 'fake_resources' }
      let(:options) { { body: { id: 1001, value: 1000 }, method: http_method } }
      let(:http_method) { :patch }

      it_behaves_like described_class

      it 'calls PATCH request on API\'s connection' do
        expect(api.connection).to receive(:patch).and_call_original

        described_class.run api, endpoint, options
      end
    end

    context 'DELETE' do
      let(:options) { { method: http_method } }
      let(:endpoint) { 'fake_resource/4' }
      let(:http_method) { :delete }

      it_behaves_like described_class

      it 'calls DELETE request on API\'s connection' do
        expect(api.connection).to receive(:delete).and_call_original

        described_class.run api, endpoint, options
      end
    end
  end
end
