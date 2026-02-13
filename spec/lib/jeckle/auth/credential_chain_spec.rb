# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Auth::CredentialChain do
  describe '#resolve' do
    it 'returns the first non-nil value' do
      chain = described_class.new(
        -> {},
        -> { 'token-from-second' },
        -> { 'token-from-third' }
      )

      expect(chain.resolve).to eq 'token-from-second'
    end

    it 'returns nil when all providers return nil' do
      chain = described_class.new(
        -> {},
        -> {}
      )

      expect(chain.resolve).to be_nil
    end

    it 'returns the first provider value when available' do
      chain = described_class.new(
        -> { 'first' },
        -> { 'second' }
      )

      expect(chain.resolve).to eq 'first'
    end
  end
end
