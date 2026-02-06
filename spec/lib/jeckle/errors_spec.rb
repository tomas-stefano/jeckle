# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Jeckle error hierarchy' do
  describe Jeckle::Error do
    it 'inherits from StandardError' do
      expect(described_class).to be < StandardError
    end
  end

  describe Jeckle::ConnectionError do
    it 'inherits from Jeckle::Error' do
      expect(described_class).to be < Jeckle::Error
    end
  end

  describe Jeckle::TimeoutError do
    it 'inherits from Jeckle::Error' do
      expect(described_class).to be < Jeckle::Error
    end
  end

  describe Jeckle::HTTPError do
    it 'inherits from Jeckle::Error' do
      expect(described_class).to be < Jeckle::Error
    end

    it 'exposes status, body, and request_id' do
      error = described_class.new('fail', status: 418, body: 'teapot', request_id: 'req-123')
      expect(error.status).to eq 418
      expect(error.body).to eq 'teapot'
      expect(error.request_id).to eq 'req-123'
      expect(error.message).to eq 'fail'
    end

    it 'defaults status, body, and request_id to nil' do
      error = described_class.new
      expect(error.status).to be_nil
      expect(error.body).to be_nil
      expect(error.request_id).to be_nil
    end
  end

  describe Jeckle::ClientError do
    it 'inherits from Jeckle::HTTPError' do
      expect(described_class).to be < Jeckle::HTTPError
    end
  end

  describe Jeckle::ServerError do
    it 'inherits from Jeckle::HTTPError' do
      expect(described_class).to be < Jeckle::HTTPError
    end
  end

  {
    Jeckle::BadRequestError => { status: 400, parent: Jeckle::ClientError },
    Jeckle::UnauthorizedError => { status: 401, parent: Jeckle::ClientError },
    Jeckle::ForbiddenError => { status: 403, parent: Jeckle::ClientError },
    Jeckle::NotFoundError => { status: 404, parent: Jeckle::ClientError },
    Jeckle::UnprocessableEntityError => { status: 422, parent: Jeckle::ClientError },
    Jeckle::TooManyRequestsError => { status: 429, parent: Jeckle::ClientError },
    Jeckle::InternalServerError => { status: 500, parent: Jeckle::ServerError },
    Jeckle::ServiceUnavailableError => { status: 503, parent: Jeckle::ServerError }
  }.each do |error_class, meta|
    describe error_class do
      it "inherits from #{meta[:parent]}" do
        expect(error_class).to be < meta[:parent]
      end

      it "has DEFAULT_STATUS #{meta[:status]}" do
        expect(error_class::DEFAULT_STATUS).to eq meta[:status]
      end

      it "defaults status to #{meta[:status]}" do
        error = error_class.new
        expect(error.status).to eq meta[:status]
      end

      it 'allows custom status, body and message' do
        error = error_class.new('custom', status: 999, body: 'data')
        expect(error.message).to eq 'custom'
        expect(error.status).to eq 999
        expect(error.body).to eq 'data'
      end
    end
  end
end
