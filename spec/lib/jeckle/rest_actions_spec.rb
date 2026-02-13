# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::RESTActions do
  describe 'Collection' do
    it 'includes all operation modules' do
      ancestors = Jeckle::RESTActions::Collection.ancestors
      expect(ancestors).to include(Jeckle::Operations::Find)
      expect(ancestors).to include(Jeckle::Operations::List)
      expect(ancestors).to include(Jeckle::Operations::Create)
      expect(ancestors).to include(Jeckle::Operations::Update)
      expect(ancestors).to include(Jeckle::Operations::Delete)
    end
  end
end
