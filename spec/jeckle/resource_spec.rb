require 'spec_helper'

class CustomAttributeMappingResource
  include Jeckle::Resource

  attribute :first_name, String

  mapping do
    attribute :first_name, :FirstName
  end
end

RSpec.describe Jeckle::Resource do
  subject(:fake_resource) { FakeResource.new }

  it 'includes jeckle/model' do
    expect(FakeResource.ancestors).to include Jeckle::Model
  end

  it 'includes active_model/naming' do
    expect(FakeResource.ancestors).to include ActiveModel::Naming
  end

  it 'includes jeckle http' do
    expect(FakeResource.ancestors).to include Jeckle::HTTP
  end

  it 'includes jeckle rest actions' do
    expect(FakeResource.ancestors).to include Jeckle::RESTActions
  end

  describe 'custom attribute key mapping' do
    it 'initializes attributes by key options' do
      resource = CustomAttributeMappingResource.new(FirstName: 'First Name')
      expect(resource.first_name).to eq('First Name')
    end
  end
end
