# frozen_string_literal: true

RSpec.shared_examples_for Jeckle::Request do
  let(:api_params) { api.params.stringify_keys }

  before do
    allow_any_instance_of(Faraday::Request).to receive(:params=).with(any_args).and_call_original
    allow_any_instance_of(Faraday::Request).to receive(:headers=).with(any_args).and_call_original
  end

  it 'sets request URL' do
    expect_any_instance_of(Faraday::Request).to receive(:url).with endpoint

    described_class.run api, endpoint, options
  end

  it 'sets global api params defined via register block' do
    expect_any_instance_of(Faraday::Request).to receive(:params=).with(api_params).
      at_least(:once).and_call_original

    described_class.run api, endpoint, options
  end

  it 'sets request params' do
    expect_any_instance_of(Faraday::Request).to receive(:params=).with(options).
      at_least(:once).and_call_original

    described_class.run api, endpoint, options
  end

  it 'sets global api headers defined via register block' do
    expect_any_instance_of(Faraday::Request).to receive(:headers=).with(api.connection.headers).
      at_least(:once).and_call_original

    described_class.run api, endpoint, options
  end

  context 'when has headers option' do
    let(:options) { { headers: { 'Accept' => 'application/json' } } }
    let(:expected_headers) { api.connection.headers.merge options[:headers] }

    it 'merges request headers with global api headers' do
      expect_any_instance_of(Faraday::Request).to receive(:headers=).with(expected_headers).
        at_least(:once).and_call_original

      described_class.run api, endpoint, options
    end
  end
end
