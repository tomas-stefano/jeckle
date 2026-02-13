# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Pagination::Offset do
  subject(:strategy) { described_class.new }

  describe '#paginate' do
    it 'adds page and per_page params' do
      result = strategy.paginate({ status: 'active' }, 25, { page: 2 })
      expect(result).to eq(status: 'active', page: 2, per_page: 25)
    end

    it 'defaults to page 1' do
      result = strategy.paginate({}, 10, {})
      expect(result).to eq(page: 1, per_page: 10)
    end

    it 'supports custom param names' do
      custom = described_class.new(page_param: :p, per_page_param: :limit)
      result = custom.paginate({}, 50, { page: 3 })
      expect(result).to eq(p: 3, limit: 50)
    end
  end

  describe '#next_context' do
    it 'returns next page when full page is returned' do
      records = Array.new(25) { OpenStruct.new }
      result = strategy.next_context(records, 25, nil, { page: 1 })
      expect(result).to eq(page: 2)
    end

    it 'returns nil when page is short' do
      records = Array.new(10) { OpenStruct.new }
      result = strategy.next_context(records, 25, nil, { page: 1 })
      expect(result).to be_nil
    end

    it 'returns nil when page is empty' do
      result = strategy.next_context([], 25, nil, { page: 1 })
      expect(result).to be_nil
    end
  end
end
