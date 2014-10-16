require 'spec_helper'

RSpec.describe Jeckle::Resource do
  subject(:fake_resource) { FakeResource.new }

  let(:api) { FakeResource.api_mapping[:default_api] }

  it 'includes jeckle/model' do
    expect(FakeResource.ancestors).to include Jeckle::Model
  end

  it 'includes active_model/naming' do
    expect(FakeResource.ancestors).to include ActiveModel::Naming
  end

  describe '.resource_name' do
    it 'returns resource name based on class name' do
      expect(FakeResource.resource_name).to eq 'fake_resources'
    end

    context 'when resource class is namespaced' do
      before do
        MySuperApi = Module.new
        MySuperApi::FakeResource = Class.new(::FakeResource)
      end

      it 'ignores namespace' do
        expect(MySuperApi::FakeResource.resource_name).to eq 'fake_resources'
      end
    end
  end

  describe '.api_mapping' do
    it 'returns a hash containing default api' do
      expect(FakeResource.api_mapping).to match(
        default_api: an_instance_of(Jeckle::API)
      )
    end

    context 'when resource is inherited' do
      let(:inherited_class) { Class.new(FakeResource) }

      it "contains the parent's api_mapping" do
        expect(inherited_class.api_mapping).to eq FakeResource.api_mapping
      end

      context 'when api_mapping is changed' do
        it "does not affect the parent" do
          inherited_class.default_api :another_api

          expect(FakeResource.api_mapping).not_to eq inherited_class.api_mapping
          expect(FakeResource.api_mapping[:default_api]).to eq Jeckle::Setup.registered_apis[:my_super_api]
        end
      end
    end
  end

  describe '.default_api' do
    context 'when defining a registered API via Jeckle::Setup' do
      it 'returns the assigned API' do
        expect(FakeResource.default_api :my_super_api).to be_kind_of Jeckle::API
      end

      it 'assigns API do api_mapping' do
        expect(FakeResource.api_mapping).to have_key :default_api
      end
    end

    context 'when defining an inexistent API' do
      it 'raises NoSuchAPIError' do
        expect { FakeResource.default_api :unknown_api }.to raise_error Jeckle::NoSuchAPIError
      end
    end
  end

  describe '.find' do
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: { id: 1001 }) }

    it 'calls default API connection with GET' do
      expect(Jeckle::Request).to receive(:run)
        .with(api, 'fake_resources/1001', {}).and_return(fake_request)

      FakeResource.find 1001
    end

    it 'returns an instance of resource' do
      allow(Jeckle::Request).to receive(:run).and_return(fake_request)

      expect(FakeResource.find 1001).to be_an_instance_of(FakeResource)
    end
  end

  describe '.search' do
    let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: body) }

    let(:query) { { name: 'cocada' } }

    context 'when there are results WITHOUT root node' do
      let(:body) { [{ id: 1001 }, { id: 1002 }] }

      it 'calls default API connection with GET and search params' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', query).and_return(fake_request)

        FakeResource.search query
      end

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.search query).to match [
          an_instance_of(FakeResource),
          an_instance_of(FakeResource)
        ]
      end
    end

    context 'when there are results WITH root node' do
      let(:body) do
        { 'fake_resources' => [{ id: 1001 }, { id: 1002 } ] }
      end

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.search query).to match [
          an_instance_of(FakeResource),
          an_instance_of(FakeResource)
        ]
      end
    end

    context 'when there are no results' do
      let(:fake_request) { OpenStruct.new response: OpenStruct.new(body: nil) }

      it 'returns an empty Array' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.search query).to match []
      end
    end
  end
end
