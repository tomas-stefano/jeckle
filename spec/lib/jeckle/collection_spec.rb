# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Collection do
  let(:api) { FakeResource.api_mapping[:default_api] }

  describe '#each' do
    context 'when there are multiple pages' do
      let(:page1_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }, { id: 2 }]) }
      let(:page2_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 3 }]) }

      it 'lazily fetches pages and stops on short page' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', { params: { page: 1, per_page: 2 } })
          .and_return(page1_request)
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', { params: { page: 2, per_page: 2 } })
          .and_return(page2_request)

        collection = described_class.new(resource_class: FakeResource, per_page: 2)
        results = collection.to_a

        expect(results.size).to eq 3
        expect(results).to all(be_an_instance_of(FakeResource))
      end
    end

    context 'when a page returns empty' do
      let(:empty_request) { OpenStruct.new response: OpenStruct.new(body: []) }

      it 'stops immediately' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', { params: { page: 1, per_page: 25 } })
          .and_return(empty_request)

        collection = described_class.new(resource_class: FakeResource)
        expect(collection.to_a).to eq []
      end
    end

    it 'returns an Enumerator when no block is given' do
      collection = described_class.new(resource_class: FakeResource)
      expect(collection.each).to be_a(Enumerator)
    end
  end

  describe '#page' do
    let(:page_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }, { id: 2 }]) }

    it 'fetches a single page of resources' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources', { params: { page: 3, per_page: 10 } })
        .and_return(page_request)

      collection = described_class.new(resource_class: FakeResource, per_page: 10)
      results = collection.page(3)

      expect(results.size).to eq 2
      expect(results).to all(be_an_instance_of(FakeResource))
    end
  end

  describe 'custom param names' do
    let(:page_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }]) }

    it 'uses custom page_param and per_page_param' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources', { params: { p: 1, limit: 5, status: 'active' } })
        .and_return(page_request)

      collection = described_class.new(
        resource_class: FakeResource,
        per_page: 5,
        page_param: :p,
        per_page_param: :limit,
        params: { status: 'active' }
      )

      collection.page(1)
    end
  end

  describe 'list_each integration' do
    let(:page_request) { OpenStruct.new response: OpenStruct.new(body: [{ id: 1 }]) }

    it 'returns a Collection from the resource class' do
      collection = FakeResource.list_each(per_page: 10, status: 'active')

      expect(collection).to be_a(described_class)
    end
  end
end
