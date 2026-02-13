# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Pagination::Cursor do
  subject(:strategy) { described_class.new(cursor_param: :starting_after, limit_param: :limit) }

  describe '#paginate' do
    it 'adds limit param on first page' do
      result = strategy.paginate({ status: 'active' }, 25, {})
      expect(result).to eq(status: 'active', limit: 25)
    end

    it 'adds cursor on subsequent pages' do
      result = strategy.paginate({}, 25, { cursor: 'obj_abc' })
      expect(result).to eq(limit: 25, starting_after: 'obj_abc')
    end
  end

  describe '#next_context' do
    it 'returns cursor from last record ID' do
      records = [OpenStruct.new(id: 1), OpenStruct.new(id: 2), OpenStruct.new(id: 3)]
      result = strategy.next_context(records, 3, nil, {})
      expect(result).to eq(cursor: 3)
    end

    it 'returns nil when page is short' do
      records = [OpenStruct.new(id: 1)]
      result = strategy.next_context(records, 3, nil, {})
      expect(result).to be_nil
    end

    it 'returns nil when page is empty' do
      result = strategy.next_context([], 3, nil, {})
      expect(result).to be_nil
    end

    it 'supports custom cursor_field' do
      custom = described_class.new(cursor_field: :cursor_token)
      records = [OpenStruct.new(cursor_token: 'abc'), OpenStruct.new(cursor_token: 'xyz')]
      result = custom.next_context(records, 2, nil, {})
      expect(result).to eq(cursor: 'xyz')
    end
  end
end
