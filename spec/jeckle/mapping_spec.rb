require 'spec_helper'

class CustomAttributeMappingResource
  include Jeckle::Resource

  attribute :first_name, String

  mapping do
    attribute :first_name, :FirstName
  end
end

RSpec.describe Jeckle::CustomAttributeMapping do
  let(:first_name) { 'First Name' }
  let(:resource) { CustomAttributeMappingResource.new(FirstName: first_name) }

  describe '#mapping' do
    it 'initializes attributes by mapping options' do
      expect(resource.first_name).to eq first_name
    end
  end
end
