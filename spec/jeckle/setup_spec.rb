require 'spec_helper'

RSpec.describe Jeckle::Setup do
  describe '.register' do
    context 'when block is given' do
      let(:registered_apis) { Jeckle::Setup.registered_apis }

      before do
        Jeckle::Setup.register(:my_super_api) do |api|
          api.base_uri = 'http://my_super.api.com.br'
        end
      end

      it 'returns a new registered API' do
        expect(registered_apis).to have_key(:my_super_api)
      end

      it 'assigns the base uri to the api instance' do
        expect(registered_apis[:my_super_api]).to_not be nil
        expect(registered_apis[:my_super_api].base_uri).to eq 'http://my_super.api.com.br'
      end
    end

    context 'when block is not given' do
      it 'raises no block given exception' do
        expect {
          Jeckle::Setup.register(:my_api)
        }.to raise_exception(LocalJumpError)
      end
    end
  end
end
