# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Middleware::Instrumentation do
  describe 'Faraday registration' do
    it 'is registered as :jeckle_instrumentation' do
      expect(Faraday::Request.lookup_middleware(:jeckle_instrumentation)).to eq described_class
    end
  end

  describe '#call' do
    let(:app) { ->(env) { Faraday::Response.new(env) } }
    let(:middleware) { described_class.new(app) }

    context 'when ActiveSupport::Notifications is not available' do
      before do
        hide_const('ActiveSupport::Notifications')
      end

      it 'calls the app normally' do
        env = Faraday::Env.from(method: :get, url: URI('http://example.com/test'),
                                request_headers: {})
        result = middleware.call(env)
        expect(result).to be_a(Faraday::Response)
      end
    end
  end
end
