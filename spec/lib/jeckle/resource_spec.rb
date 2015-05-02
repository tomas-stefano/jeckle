require 'spec_helper'

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
end
