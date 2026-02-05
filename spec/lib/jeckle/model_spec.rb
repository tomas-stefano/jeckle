# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Model do
  it 'includes active_model/validations' do
    expect(FakeModel.ancestors).to include ActiveModel::Validations
  end

  it 'inherits from Dry::Struct' do
    expect(FakeModel).to be < Dry::Struct
  end
end
