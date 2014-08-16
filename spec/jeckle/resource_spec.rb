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
end
