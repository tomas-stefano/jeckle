require 'spec_helper'

class AttributeAliasingResource
  include Jeckle::Resource

  attribute :firstName, String, as: :first_name
end

RSpec.describe Jeckle::Model::AttributeAliasing do
  let(:first_name) { 'First Name' }
  let(:resource) { AttributeAliasingResource.new(firstName: first_name) }

  describe '.attribute' do
    it 'initializes attributes by :as options' do
      expect(resource.first_name).to eq first_name
      expect(resource.firstName).to eq first_name
    end
  end
end
