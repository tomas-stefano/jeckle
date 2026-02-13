# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Pagination::LinkHeader do
  subject(:strategy) { described_class.new }

  describe '#paginate' do
    it 'adds per_page on first request' do
      result = strategy.paginate({ status: 'active' }, 25, {})
      expect(result).to eq(status: 'active', per_page: 25)
    end

    it 'uses next_params from context' do
      result = strategy.paginate({ status: 'active' }, 25, { next_params: { page: 2, per_page: 25 } })
      expect(result).to eq(status: 'active', page: 2, per_page: 25)
    end
  end

  describe '#next_context' do
    let(:records) { [OpenStruct.new(id: 1)] }

    it 'extracts next URL from Link header' do
      link = '<https://api.example.com/users?page=3&per_page=25>; rel="next"'
      response = OpenStruct.new(headers: { 'Link' => link })

      result = strategy.next_context(records, 25, response, {})
      expect(result).to eq(next_params: { page: '3', per_page: '25' })
    end

    it 'returns nil when no Link header' do
      response = OpenStruct.new(headers: {})
      result = strategy.next_context(records, 25, response, {})
      expect(result).to be_nil
    end

    it 'returns nil when no next rel in Link header' do
      link = '<https://api.example.com/users?page=1>; rel="prev"'
      response = OpenStruct.new(headers: { 'Link' => link })

      result = strategy.next_context(records, 25, response, {})
      expect(result).to be_nil
    end

    it 'returns nil when records are empty' do
      link = '<https://api.example.com/users?page=2>; rel="next"'
      response = OpenStruct.new(headers: { 'Link' => link })

      result = strategy.next_context([], 25, response, {})
      expect(result).to be_nil
    end
  end
end
