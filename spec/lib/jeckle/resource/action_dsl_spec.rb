require 'spec_helper'

RSpec.describe Jeckle::Resource::ActionDSL do
  before :all do
    class PhotoSample
      include Jeckle::Resource

      api :my_super_api

      attribute :id, Integer
      attribute :url, String
    end
  end

  after :all do
    Object.send :remove_const, :PhotoSample
  end

  let(:resource_class) { PhotoSample }
  let(:resource_name)  { resource_class.resource_name }
  let(:api) { resource_class.api_mapping[:default_api] }

  describe '.action' do
    context 'on collection' do
      let(:action_name) { :last_month }
      let(:path) { nil }
      let(:default_endpoint) { "#{resource_name}/#{action_name}" }

      before { resource_class.action action_name, on: :collection, path: path }

      it 'defines a class method for the action' do
        expect(resource_class).to respond_to action_name
      end

      describe 'defined class method' do
        let(:request) { double(response: response).as_null_object }

        let(:response) { double(body: response_body, success?: response_successful).as_null_object }
        let(:response_body) { [{ id: 1001, url: 'http://img.co/1.png' }, { id: 1002, url: 'http://img.co/2.png' }] }
        let(:response_successful) { true }

        before { allow(Jeckle::Request).to receive(:run).and_return request }

        it "runs request to resource's API" do
          expect(Jeckle::Request).to receive(:run).with(api, default_endpoint, {}).
            and_return request

          resource_class.last_month
        end

        context 'when path option is present' do
          let(:path) { 'one_month_ago' }
          let(:path_endpoint) { "#{resource_name}/#{path}" }

          it 'runs request to given path' do
            expect(Jeckle::Request).to receive(:run).with(api, path_endpoint, {}).
              and_return request

            resource_class.last_month
          end
        end

        context 'with params' do
          let(:params) { { user: 'jane' } }

          it 'runs request with given params' do
            expect(Jeckle::Request).to receive(:run).with(api, default_endpoint, params).
              and_return request

            resource_class.last_month params
          end
        end

        context 'when response is successful' do
          let(:response_successful) { true }

          it 'returns an array of resources' do
            resources = resource_class.last_month

            expect(resources).to match [
              an_instance_of(resource_class),
              an_instance_of(resource_class)
            ]
          end
        end

        context 'when response is not successful' do
          let(:response_successful) { false }

          it 'returns an empty array' do
            resources = resource_class.last_month

            expect(resources).to be_empty
          end
        end
      end
    end
  end
end
