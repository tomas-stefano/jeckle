require 'spec_helper'

RSpec.describe Jeckle::Setup do
  describe '.register' do
    context 'when block is given' do
      let(:registered_apis) { Jeckle::Setup.registered_apis }

      before do
        Jeckle::Setup.register(:my_super_api) do |api|
          api.base_uri = 'http://my_super.api.com.br'
          api.headers = { 'Content-Type' => 'application/json' }
          api.logger = Logger.new(STDOUT)
          api.basic_auth = { username: 'steven_seagal', password: 'youAlwaysLose' }
        end
      end

      it 'returns a new registered API' do
        expect(registered_apis).to have_key(:my_super_api)
      end

      describe 'base uri' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].base_uri).to eq 'http://my_super.api.com.br'
        end
      end

      describe 'headers' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].headers).to eq 'Content-Type' => 'application/json'
        end
      end

      describe 'logger' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].logger).to be_kind_of Logger
        end
      end

      describe 'basic auth' do
        context 'when username and password are defined' do
          it 'assigns to the api instance' do
            expect(registered_apis[:my_super_api].basic_auth).to eq username: 'steven_seagal', password: 'youAlwaysLose'
          end
        end

        context 'when neither username or password are defined' do
          it 'raises no username or password exception' do
            expect {
              Jeckle::Setup.register :my_other_api do |api|
                api.basic_auth = { foo: :bar, username: 'heckle' }
              end
            }.to raise_exception(Jeckle::API::NoUsernameOrPasswordError)
          end
        end
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
