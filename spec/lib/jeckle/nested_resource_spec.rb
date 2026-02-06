# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::NestedResource do
  let(:api) { FakeComment.api_mapping[:default_api] }

  describe '.belongs_to' do
    it 'sets the parent resource' do
      expect(FakeComment.parent_resource).to eq :post
    end
  end

  describe '.resolve_endpoint' do
    it 'builds nested path from parent ID' do
      params = { post_id: 123 }
      expect(FakeComment.resolve_endpoint(params)).to eq 'posts/123/fake_comments'
    end

    it 'removes parent_id from params' do
      params = { post_id: 123, status: 'active' }
      FakeComment.resolve_endpoint(params)
      expect(params).to eq(status: 'active')
    end

    it 'raises ArgumentError when parent_id is missing' do
      expect { FakeComment.resolve_endpoint({}) }
        .to raise_error(Jeckle::ArgumentError, /post_id is required/)
    end
  end

  describe 'CRUD with nested resource' do
    describe '.find' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 456, body: 'Hello' }) }

      it 'builds nested path' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/123/fake_comments/456', {})
          .and_return(fake_request)

        FakeComment.find(456, post_id: 123)
      end
    end

    describe '.list' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }]) }

      it 'builds nested path' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/123/fake_comments', { params: {} })
          .and_return(fake_request)

        FakeComment.list(post_id: 123)
      end
    end

    describe '.create' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 789, body: 'New' }) }

      it 'builds nested path and excludes parent_id from body' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/123/fake_comments', { method: :post, body: { body: 'New' } })
          .and_return(fake_request)

        FakeComment.create(post_id: 123, body: 'New')
      end
    end

    describe '.update' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 456, body: 'Updated' }) }

      it 'builds nested path' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/123/fake_comments/456', { method: :patch, body: { body: 'Updated' } })
          .and_return(fake_request)

        FakeComment.update(456, post_id: 123, body: 'Updated')
      end
    end

    describe '.destroy' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

      it 'builds nested path' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/123/fake_comments/456', { method: :delete })
          .and_return(fake_request)

        FakeComment.destroy(456, post_id: 123)
      end
    end
  end

  describe 'non-nested resource' do
    it 'resolve_endpoint returns resource_name' do
      expect(FakeResource.resolve_endpoint({})).to eq 'fake_resources'
    end
  end
end
