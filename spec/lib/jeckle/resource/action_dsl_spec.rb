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

  after(:all) { Object.send :remove_const, :PhotoSample }

  let(:resource_class) { PhotoSample }
  let(:api) { resource_class.api_mapping[:default_api] }

  describe '.action' do
    context 'when `on` is invalid' do
      it 'raises Jeckle::ArgumentError' do
        expect {
          resource_class.action :hat, on: :your_head
        }.to raise_error Jeckle::ArgumentError, /Invalid value for \:on/
      end
    end

    context 'when `on` is valid' do
      let(:resource_name)  { resource_class.resource_name }
      let(:resource) { resource_class.new id: 9821, url: 'http://img.co/9821.png' }

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

          subject { resource_class.send action_name }

          before { allow(Jeckle::Request).to receive(:run).and_return request }

          describe 'options' do
            context 'when path is present' do
              it 'runs request to given path' do
                subject

                expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
              end
            end

            context 'when params is present' do
              context 'as raw hash' do
                let(:params) { { user: 'jane' } }

                it 'runs request with given params' do
                  subject

                  expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, params)
                end
              end

              context 'as a block' do
                let(:params) { -> { { since: (2 + 2) } } }

                it 'runs request with given params' do
                  subject

                  expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, { since: 4 })
                end
              end
            end
          end

          it "runs request to resource's API" do
            subject

            expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
          end

          context 'when response is successful' do
            let(:response_successful) { true }

            it 'returns an array of resources' do
              expect(subject).to match [
                an_instance_of(resource_class),
                an_instance_of(resource_class)
              ]
            end
          end

          context 'when response is not successful' do
            let(:response_successful) { false }

            it 'returns an empty array' do
              resources = subject

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
          let(:response_body) { { resource_name => resource.attributes } }
          let(:response_successful) { true }

          subject { resource.public_send action_name }

          before { allow(Jeckle::Request).to receive(:run).and_return request }

          describe 'options' do
            context 'when path is present' do
              it 'runs request to given path' do
                subject

                expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
              end
            end

            context 'when params is present' do
              context 'as raw hash' do
                let(:params) { { user: 'jane' } }

                it 'runs request with given params' do
                  subject

                  expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, params)
                end
              end

              context 'as a block' do
                let(:params) { -> { attributes } }

                it 'runs request with given params' do
                  subject

                  expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, resource.attributes)
                end

                it 'defines itself lazily' do
                  resource.url = 'http://duckduckgo.com'
                  attributes = resource.attributes

                  subject

                  expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, attributes)
                end
              end
            end
          end

          it "runs request to resource's API" do
            subject

            expect(Jeckle::Request).to have_received(:run).with(api, path_endpoint, {})
          end
        end
      end
    end
  end
end
