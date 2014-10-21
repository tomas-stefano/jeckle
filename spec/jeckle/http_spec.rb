require 'spec_helper'

RSpec.describe Jeckle::HTTP do
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
end