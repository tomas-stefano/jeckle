# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jeckle::Setup do
  describe '.register' do
    context 'when block is given' do
      let(:registered_apis) { Jeckle::Setup.registered_apis }

      it 'returns a new registered API' do
        expect(registered_apis).to have_key(:my_super_api)
      end

      describe 'base uri' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].base_uri).to eq 'http://my-super-api.com.br/api/v1'
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
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].basic_auth).to eq username: 'steven_seagal', password: 'youAlwaysLose'
        end
      end

      describe 'query string' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].params).to eq(hello: 'world')
        end
      end

      describe 'namespaces' do
        it 'assigns to the api instance' do
          expect(registered_apis[:my_super_api].namespaces).to eq prefix: 'api', version: 'v1'
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
