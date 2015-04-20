require 'spec_helper'

class CustomAttributeMappingResource
  include Jeckle::Resource

  attribute :firstName, String, as: :first_name
end

RSpec.describe Jeckle::CustomAttributeMapping do
  let(:first_name) { 'First Name' }
  let(:resource) { CustomAttributeMappingResource.new(firstName: first_name) }

  describe '.attribute' do
    it 'initializes attributes by :as options' do
      expect(resource.first_name).to eq first_name
      expect(resource.firstName).to eq first_name
    end
  end
end
