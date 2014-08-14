require 'spec_helper'

RSpec.describe Jeckle do
  subject(:fake_resource) { FakeResource.new }

  it 'includes active_model/validations' do
    expect(FakeResource.ancestors).to include ActiveModel::Validations
  end

  it 'includes active_model/naming' do
    expect(FakeResource.ancestors).to include ActiveModel::Naming
  end

  describe '.resource_name' do
    it 'returns snake case model name by default' do
      expect(FakeResource.resource_name).to eq 'fake_resource'
    end
  end
end
