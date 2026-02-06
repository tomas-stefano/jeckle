# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Middleware::RaiseError do
  let(:app) { ->(env) { Faraday::Response.new(env) } }
  let(:middleware) { described_class.new(app) }
  let(:env) do
    Faraday::Env.from(status: status, body: body, reason_phrase: reason_phrase,
                      response_headers: response_headers)
  end
  let(:body) { '{"error":"something"}' }
  let(:reason_phrase) { nil }
  let(:response_headers) { {} }

  describe '#on_complete' do
    context 'when status is 2xx' do
      let(:status) { 200 }

      it 'does not raise' do
        expect { middleware.on_complete(env) }.not_to raise_error
      end
    end

    context 'when status is 3xx' do
      let(:status) { 301 }

      it 'does not raise' do
        expect { middleware.on_complete(env) }.not_to raise_error
      end
    end

    {
      400 => Jeckle::BadRequestError,
      401 => Jeckle::UnauthorizedError,
      403 => Jeckle::ForbiddenError,
      404 => Jeckle::NotFoundError,
      422 => Jeckle::UnprocessableEntityError,
      429 => Jeckle::TooManyRequestsError,
      500 => Jeckle::InternalServerError,
      503 => Jeckle::ServiceUnavailableError
    }.each do |code, error_class|
      context "when status is #{code}" do
        let(:status) { code }
        let(:reason_phrase) { "Error #{code}" }

        it "raises #{error_class}" do
          expect { middleware.on_complete(env) }.to raise_error(error_class) do |error|
            expect(error.status).to eq code
            expect(error.body).to eq body
          end
        end
      end
    end

    context 'when status is an unmapped 4xx' do
      let(:status) { 418 }
      let(:reason_phrase) { "I'm a teapot" }

      it 'raises Jeckle::ClientError' do
        expect { middleware.on_complete(env) }.to raise_error(Jeckle::ClientError) do |error|
          expect(error.status).to eq 418
        end
      end
    end

    context 'when response includes X-Request-Id header' do
      let(:status) { 404 }
      let(:reason_phrase) { 'Not Found' }
      let(:response_headers) { { 'X-Request-Id' => 'req-abc-123' } }

      it 'includes request_id in the error' do
        expect { middleware.on_complete(env) }.to raise_error(Jeckle::NotFoundError) do |error|
          expect(error.request_id).to eq 'req-abc-123'
        end
      end
    end

    context 'when response has no request ID header' do
      let(:status) { 500 }
      let(:reason_phrase) { 'Internal Server Error' }
      let(:response_headers) { {} }

      it 'sets request_id to nil' do
        expect { middleware.on_complete(env) }.to raise_error(Jeckle::InternalServerError) do |error|
          expect(error.request_id).to be_nil
        end
      end
    end

    context 'when status is an unmapped 5xx' do
      let(:status) { 502 }
      let(:reason_phrase) { 'Bad Gateway' }

      it 'raises Jeckle::ServerError' do
        expect { middleware.on_complete(env) }.to raise_error(Jeckle::ServerError) do |error|
          expect(error.status).to eq 502
        end
      end
    end
  end

  describe 'Faraday registration' do
    it 'is registered as :jeckle_raise_error' do
      expect(Faraday::Response.lookup_middleware(:jeckle_raise_error)).to eq described_class
    end
  end
end
