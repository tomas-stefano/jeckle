require 'spec_helper'

RSpec.describe Jeckle::Resource::ActionDSL do
  before :all do
    class TestPhoto
      include Jeckle::Resource

      api :my_super_api

      action :publish
      action :publish_with_custom_path, path: 'publish_photo'
      action :publish_with_hash_params, params: { foo: :bar }
      action :publish_with_block_params, params: -> { { url: url } }

      action :latest, on: :collection
      action :latest_with_custom_path, on: :collection, path: 'latest_photos'
      action :latest_with_hash_params, on: :collection, params: { since: :yesterday }
      action :latest_with_block_params, on: :collection, params: -> { { count: 2 + 2 } }

      attribute :id, Integer
      attribute :url, String
    end
  end

  after(:all) { Object.send :remove_const, :TestPhoto }

  let(:resource_name) { resource_class.resource_name }
  let(:resource_class) { TestPhoto }
  let(:api) { resource_class.api_mapping[:default_api] }

  describe '.action' do
    let(:response_successful) { true }
    let(:resource) { resource_class.new id: 9821, url: 'http://img.co/9821.png' }
    let(:request) { double(response: response).as_null_object }

    before { allow(Jeckle::Request).to receive(:run).and_return request }

    context 'when `on` is invalid' do
      let(:response) { double(body: response_body, success?: response_successful).as_null_object }
      let(:response_body) { [{ id: 1001, url: 'http://img.co/1.png' }, { id: 1002, url: 'http://img.co/2.png' }] }

      it 'raises Jeckle::ArgumentError' do
        expect {
          resource_class.class_eval do
            action :hat, on: :your_head
          end
        }.to raise_error Jeckle::ArgumentError, /Invalid value for \:on/
      end
    end

    context 'when `on` is collection' do
      let(:response) { double(body: response_body, success?: response_successful).as_null_object }
      let(:response_body) { [{ id: 1001, url: 'http://img.co/1.png' }, { id: 1002, url: 'http://img.co/2.png' }] }

      describe 'defined class method' do
        it 'runs member action' do
          resource_class.latest

          expect(Jeckle::Request).to have_received(:run).with(api, "test_photos/latest", {})
        end

        context 'with `path` option' do
          it 'runs request with given path' do
            resource_class.latest_with_custom_path

            expect(Jeckle::Request).to have_received(:run)
              .with(api, "test_photos/latest_photos", {})
          end
        end

        context 'with `params` option' do
          context 'as hash' do
            it 'runs request with hash params' do
              resource_class.latest_with_hash_params

              expect(Jeckle::Request).to have_received(:run)
                .with(api, "test_photos/latest_with_hash_params", { since: :yesterday })
            end
          end

          context 'as block' do
            it 'runs request with lazily evaluated params' do
              resource_class.latest_with_block_params

              expect(Jeckle::Request).to have_received(:run)
                .with(api, "test_photos/latest_with_block_params", { count: 4 })
            end
          end
        end
      end

      context 'with inline params' do
        let(:extra_params) { { foo: :bar } }

        it "runs request to resource's API forwarding params" do
          resource_class.latest extra_params

          expect(Jeckle::Request).to have_received(:run).with(api, "test_photos/latest", extra_params)
        end
      end

      context 'when response is successful' do
        let(:response_successful) { true }

        it 'returns an array of resources' do
          expect(resource_class.latest).to match [
            an_instance_of(resource_class),
            an_instance_of(resource_class)
          ]
        end
      end

      context 'when response is not successful' do
        let(:response_successful) { false }

        it 'returns an empty array' do
          expect(resource_class.latest).to be_empty
        end
      end
    end

    context 'when `on` is member' do
      describe 'defined instance method' do
        let(:response) { double(body: response_body, success?: response_successful).as_null_object }
        let(:response_body) { { resource_name => resource.attributes } }
        let(:response_successful) { true }

        it 'runs member action' do
          resource.publish

          expect(Jeckle::Request).to have_received(:run).with(api, "test_photos/#{resource.id}/publish", {})
        end

        context 'with `path` option' do
          it 'runs request with given path' do
            resource.publish_with_custom_path

            expect(Jeckle::Request).to have_received(:run)
              .with(api, "test_photos/#{resource.id}/publish_photo", {})
          end
        end

        context 'with `params` option' do
          context 'as hash' do
            it 'runs request with hash params' do
              resource.publish_with_hash_params

              expect(Jeckle::Request).to have_received(:run)
                .with(api, "test_photos/#{resource.id}/publish_with_hash_params", { foo: :bar })
            end
          end

          context 'as block' do
            it 'runs request with lazily evaluated params' do
              resource.url = 'http://duckduckgo.com'

              resource.publish_with_block_params

              expect(Jeckle::Request).to have_received(:run)
                .with(api, "test_photos/#{resource.id}/publish_with_block_params", { url: 'http://duckduckgo.com' })
            end
          end
        end

        context 'with inline params' do
          let(:extra_params) { { foo: :bar } }

          it "runs request forwarding given params" do
            resource.publish extra_params

            expect(Jeckle::Request).to have_received(:run)
              .with(api, "test_photos/#{resource.id}/publish", extra_params)
          end
        end
      end
    end
  end
end
