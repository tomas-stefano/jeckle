require 'spec_helper'

RSpec.describe Jeckle::Resource do
  subject(:fake_resource) { FakeResource.new }

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
  end

  describe '.api_mapping' do
    it 'returns a hash containing default api' do
      expect(FakeResource.api_mapping).to match(
        default_api: an_instance_of(Jeckle::API)
      )
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
        expect { FakeResource.default_api :unknow_api }.to raise_error Jeckle::Setup::NoSuchAPIError
      end
    end
  end
end
