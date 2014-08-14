require 'spec_helper'

RSpec.describe Jeckle::API do
  subject(:jeckle_api) { described_class.new }

  describe '#basic_auth=' do
    context 'when there is the required credentials' do
      let(:credentials) { { username: 'sly', password: 'IAmTheLaw'} }

      before { jeckle_api.basic_auth = credentials }

      it 'assigns creditals hash' do
        expect(jeckle_api.basic_auth).to eq credentials
      end
    end

    context 'when required creadentials is missing' do
      let(:credentials) { {} }

      it 'raises a argument error NoUsernameOrPasswordError' do
        expect { jeckle_api.basic_auth = credentials }.to raise_error Jeckle::API::NoUsernameOrPasswordError
      end
    end
  end
end
