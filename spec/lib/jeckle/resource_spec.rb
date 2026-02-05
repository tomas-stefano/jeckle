# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Resource do
  it 'inherits from Jeckle::Model' do
    expect(FakeResource).to be < Jeckle::Model
  end

  it 'includes active_model/naming' do
    expect(FakeResource.ancestors).to include ActiveModel::Naming
  end

  it 'extends Jeckle::HTTP::APIMapping' do
    expect(FakeResource.singleton_class.ancestors).to include Jeckle::HTTP::APIMapping
  end

  it 'extends Jeckle::RESTActions::Collection' do
    expect(FakeResource.singleton_class.ancestors).to include Jeckle::RESTActions::Collection
  end
end
