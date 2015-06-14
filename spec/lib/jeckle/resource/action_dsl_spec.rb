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

  shared_examples_for 'ActionOptionable' do
    context 'when path option is present' do
      it 'runs request to given path' do
        expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
      end
    end

    context 'when params is present' do
      context 'as raw hash' do
        let(:params) { { user: 'jane' } }

        it 'runs request with given params' do
          expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, params)
        end
      end

      context 'as a block' do
        let(:params) { lambda { resource.attributes } }

        it 'runs request with given params' do
          expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, resource_attrs)
        end
      end
    end
  end

  after(:all) { Object.send :remove_const, :PhotoSample }

  let(:resource_class) { PhotoSample }

  describe '.action' do
    context 'when `on` is invalid' do
      it 'raises Jeckle::ArgumentError' do
        expect {
          resource_class.action :hat, on: :your_head
        }.to raise_error Jeckle::ArgumentError, /Invalid value for \:on/
      end
    end

    context 'when `on` is valid' do
      let(:api) { resource_class.api_mapping[:default_api] }
      let(:resource_name)  { resource_class.resource_name }
      let(:resource_attrs) { { id: 9821, url: 'http://img.co/9821.png' } }
      let(:resource) { resource_class.new resource_attrs }

      let(:request) { double(response: response).as_null_object }

      let(:path) { nil }
      let(:params) { nil }
      let(:action_name) { :my_fancy_action }

      before do
        resource_class.action action_name, on: target, path: path, params: params

        allow(Jeckle::Request).to receive(:run).and_return request
      end

      context 'and `on` is collection' do
        let(:target) { :collection }
        let(:path_endpoint) { "#{resource_name}/#{action_name}" }

        describe 'defined class method' do
          let(:response) { double(body: response_body, success?: response_successful).as_null_object }
          let(:response_body) { [{ id: 1001, url: 'http://img.co/1.png' }, { id: 1002, url: 'http://img.co/2.png' }] }
          let(:response_successful) { true }

          let(:resources) { resource_class.send action_name }

          it_behaves_like 'ActionOptionable'

          before do
            allow(Jeckle::Request).to receive(:run).and_return request

            resources
          end

          it "runs request to resource's API" do
            expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
          end

          context 'when response is successful' do
            let(:response_successful) { true }

            it 'returns an array of resources' do
              expect(resources).to match [
                an_instance_of(resource_class),
                an_instance_of(resource_class)
              ]
            end
          end

          context 'when response is not successful' do
            let(:response_successful) { false }

            it 'returns an empty array' do
              resources = resource_class.send action_name

              expect(resources).to be_empty
            end
          end
        end
      end

      context 'and `on` is member' do
        let(:target) { :member }
        let(:path_endpoint) { "#{resource_name}/#{resource.id}/#{action_name}" }

        describe 'defined instance method' do
          let(:response) { double(body: response_body, success?: response_successful).as_null_object }
          let(:response_body) { { resource_name => resource_attrs } }
          let(:response_successful) { true }

          before do
            allow(Jeckle::Request).to receive(:run).and_return request

            resource.public_send action_name
          end

          it_behaves_like 'ActionOptionable'

          it "runs request to resource's API" do
            expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
          end
        end
      end
    end
  end
end
