require 'spec_helper'

RSpec.describe Jeckle::Resource::ActionDSL do
  before :all do
    class Photo
      include Jeckle::Resource;

      api :my_super_api
      attribute :id, Integer
    end
  end

  after :all do
    Object.send :remove_const, :Photo
  end

  let(:api) { Photo.api_mapping[:default_api] }

  describe '.action' do
    context 'on collection' do
      let(:action_name) { :last_month }
      let(:path) { nil }

      before do
        Photo.action action_name, on: :collection, path: path
      end

      it 'defines a class method for the action' do
        expect(Photo).to respond_to action_name
      end

      describe 'defined action' do
        let(:response) { double(body: response_body, success?: true).as_null_object }
        let(:response_body) { [{ id: 1001 }, { id: 1002 }] }

        let(:request) { double(response: response).as_null_object }
        let(:params)  { { include_deleted: 'true' } }

        before { allow(Jeckle::Request).to receive(:run).and_return request }

        it "runs request to resource's API" do
          expect(Jeckle::Request).to receive(:run).with(api, anything, anything).
            and_return request

          Photo.last_month params
        end

        it 'runs request with given params' do
          expect(Jeckle::Request).to receive(:run).
            with(anything, anything, params).
            and_return request

          Photo.last_month params
        end

        it 'returns an array of resources' do
          resources = Photo.last_month params

          expect(resources).to match [
            an_instance_of(Photo),
            an_instance_of(Photo)
          ]
        end

        context 'when path is not provided' do
          let(:path) { nil }
          let(:action_endpoint) { "#{Photo.resource_name}/#{action_name}" }

          it "appends action_name to the endpoint" do
            expect(Jeckle::Request).to receive(:run).
              with(anything, action_endpoint, anything).
              and_return request

            Photo.last_month params
          end
        end

        context 'when path is provided' do
          let(:path) { 'one_month_ago' }
          let(:path_endpoint) { "#{Photo.resource_name}/#{path}" }

          it "appends given path to the endpoint" do
            expect(Jeckle::Request).to receive(:run).
              with(anything, path_endpoint, anything).
              and_return request

            Photo.last_month params
          end
        end
      end
    end
  end
end
