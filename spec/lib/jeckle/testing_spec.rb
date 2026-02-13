# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Testing do
  describe '.stubs_for' do
    after { described_class.reset! }

    it 'creates stubs for an API' do
      stubs = described_class.stubs_for(:my_api)
      expect(stubs).to be_a Faraday::Adapter::Test::Stubs
    end

    it 'reuses stubs for the same API' do
      stubs1 = described_class.stubs_for(:my_api)
      stubs2 = described_class.stubs_for(:my_api)
      expect(stubs1).to equal stubs2
    end
  end

  describe '.reset!' do
    it 'clears all stubs' do
      described_class.stubs_for(:my_api)
      described_class.reset!
      expect(described_class.stubs).to be_empty
    end
  end

  describe 'test mode on Jeckle' do
    describe '.test_mode!' do
      after { Jeckle.reset_test_stubs! }

      it 'enables test mode' do
        Jeckle.test_mode!
        expect(Jeckle).to be_test_mode
      end
    end

    describe '.reset_test_stubs!' do
      it 'disables test mode' do
        Jeckle.test_mode!
        Jeckle.reset_test_stubs!
        expect(Jeckle).not_to be_test_mode
      end
    end
  end
end
