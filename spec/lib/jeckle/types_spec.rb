# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Types do
  describe 'DateTime' do
    subject(:type) { described_class::DateTime }

    it 'coerces an ISO 8601 string' do
      result = type['2024-01-15T10:30:00Z']
      expect(result).to be_a DateTime
      expect(result.year).to eq 2024
    end

    it 'passes through DateTime values' do
      dt = DateTime.new(2024, 1, 15)
      expect(type[dt]).to equal dt
    end

    it 'coerces Time to DateTime' do
      time = Time.new(2024, 1, 15, 10, 30, 0, '+00:00')
      result = type[time]
      expect(result).to be_a DateTime
      expect(result.hour).to eq 10
    end

    it 'coerces Unix timestamp to DateTime' do
      result = type[1_705_312_200]
      expect(result).to be_a DateTime
    end
  end

  describe 'Time' do
    subject(:type) { described_class::Time }

    it 'coerces an ISO 8601 string' do
      result = type['2024-01-15T10:30:00Z']
      expect(result).to be_a Time
      expect(result.utc.hour).to eq 10
    end

    it 'passes through Time values' do
      time = Time.now
      expect(type[time]).to equal time
    end

    it 'coerces Unix integer timestamp' do
      result = type[1_705_312_200]
      expect(result).to be_a Time
    end

    it 'coerces Unix float timestamp' do
      result = type[1_705_312_200.5]
      expect(result).to be_a Time
    end
  end

  describe 'Decimal' do
    subject(:type) { described_class::Decimal }

    it 'coerces a string' do
      result = type['19.99']
      expect(result).to be_a BigDecimal
      expect(result).to eq BigDecimal('19.99')
    end

    it 'coerces an integer' do
      result = type[42]
      expect(result).to be_a BigDecimal
      expect(result).to eq BigDecimal('42')
    end

    it 'coerces a float' do
      result = type[3.14]
      expect(result).to be_a BigDecimal
    end

    it 'passes through BigDecimal values' do
      bd = BigDecimal('99.99')
      expect(type[bd]).to equal bd
    end
  end

  describe 'UUID' do
    subject(:type) { described_class::UUID }

    it 'accepts a valid lowercase UUID' do
      uuid = '550e8400-e29b-41d4-a716-446655440000'
      expect(type[uuid]).to eq uuid
    end

    it 'accepts a valid uppercase UUID' do
      uuid = '550E8400-E29B-41D4-A716-446655440000'
      expect(type[uuid]).to eq uuid
    end

    it 'rejects an invalid UUID' do
      expect { type['not-a-uuid'] }.to raise_error Dry::Types::ConstraintError
    end

    it 'rejects a UUID without dashes' do
      expect { type['550e8400e29b41d4a716446655440000'] }.to raise_error Dry::Types::ConstraintError
    end
  end

  describe 'URI' do
    subject(:type) { described_class::URI }

    it 'coerces a string to URI' do
      result = type['https://example.com/path?q=1']
      expect(result).to be_a URI::HTTPS
      expect(result.host).to eq 'example.com'
    end

    it 'passes through URI values' do
      uri = URI.parse('https://example.com')
      expect(type[uri]).to equal uri
    end
  end

  describe 'SymbolizedHash' do
    subject(:type) { described_class::SymbolizedHash }

    it 'symbolizes string keys' do
      result = type[{ 'name' => 'Jeckle', 'version' => 1 }]
      expect(result).to eq(name: 'Jeckle', version: 1)
    end

    it 'passes through already-symbolized keys' do
      hash = { name: 'Jeckle' }
      expect(type[hash]).to eq(name: 'Jeckle')
    end
  end

  describe 'StringArray' do
    subject(:type) { described_class::StringArray }

    it 'coerces elements to strings' do
      result = type[['ruby', 123, :api]]
      expect(result).to eq %w[ruby 123 api]
    end

    it 'handles an already-string array' do
      result = type[%w[a b c]]
      expect(result).to eq %w[a b c]
    end
  end

  describe 'integration with Jeckle::Model' do
    let(:model_class) do
      Class.new(Jeckle::Model) do
        attribute :started_at, Jeckle::Types::DateTime
        attribute :price, Jeckle::Types::Decimal
        attribute :tags, Jeckle::Types::StringArray
      end
    end

    it 'coerces attributes on initialization' do
      instance = model_class.new(started_at: '2024-06-01T12:00:00Z', price: '29.99', tags: [:ruby, 42])
      expect(instance.started_at).to be_a DateTime
      expect(instance.price).to eq BigDecimal('29.99')
      expect(instance.tags).to eq %w[ruby 42]
    end
  end
end
