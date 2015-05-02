require 'spec_helper'

RSpec.describe Jeckle::Resource::RESTfulActions do
  let(:api) { FakeResource.api_mapping[:default_api] }
  let(:response) { OpenStruct.new(body: body, success?: true) }
  let(:fake_request) { OpenStruct.new response: response }

  describe '.root' do
    context 'when collection is true' do
      it 'collection root name should be in plural' do
        expect(Post.collection_root_name).to eq('posts')
      end
    end

    context 'when collection is not defined' do
      it 'collection root name should be nil' do
        expect(FakeResource.collection_root_name).to be nil
      end
    end

    context 'when member option is true' do
      it 'member root name should be in singular' do
        expect(Post.member_root_name).to eq('post')
        expect(CommentLegacy.member_root_name).to eq('comment_legacy')
      end
    end

    context 'when member is false' do
      it 'member root name should be nil' do
        expect(FakeResource.member_root_name).to be nil
      end
    end

    context 'when collection is overwritten' do
      it 'collection root name should use the collection option' do
        expect(PostLegacy.collection_root_name).to eq('super-posts')
        expect(CommentLegacy.collection_root_name).to eq('super-comments')
      end
    end

    context 'when member is overwritten' do
      it 'member root name should use the member option' do
        expect(PostLegacy.member_root_name).to eq('super-post')
      end
    end
  end

  describe '.find' do
    context 'when do not have root node' do
      let(:body) do
        { id: 1001 }
      end

      it 'calls default API connection with GET' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources/1001', {}).and_return(fake_request)

        FakeResource.find 1001
      end

      it 'returns an instance of resource' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(FakeResource.find 1001).to be_an_instance_of(FakeResource)
      end
    end

    context 'when have root node in response' do
      let(:body) { { 'post' => { 'id' => 1001 } } }

      let(:post) { Post.find 1001 }

      it 'calls default API connection with GET' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'posts/1001', {}).and_return(fake_request)

        Post.find(1001)
      end

      it 'returns an instance of resource keeping the response' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)

        expect(post).to be_an_instance_of(Post)
        expect(post.id).to be(1001)
      end
    end
  end

  describe '.search' do
    let(:query) { { name: 'cocada' } }

    context 'when there are results WITHOUT root node' do
      let(:body) { [{ id: 1001 }, { id: 1002 }] }

      it 'calls default API connection with GET and search params' do
        expect(Jeckle::Request).to receive(:run)
          .with(api, 'fake_resources', query).and_return(fake_request)

        FakeResource.search query
      end

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)
        fake_resources = FakeResource.search(query)

        expect(fake_resources).to match [
          FakeResource.new(id: 1001),
          FakeResource.new(id: 1002)
        ]
      end
    end

    context 'when there are results WITH collection root node' do
      let(:body) { { 'posts' => [{ id: 1001 }, { id: 1002 }], success?: true } }

      it 'returns an Array of resources' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)
        results = Post.search(query)

        expect(results).to match [
          Post.new(id: 1001),
          Post.new(id: 1002)
        ]
      end
    end

    context 'when there are no results' do
      let(:body) { nil }

      it 'returns an empty Array' do
        allow(Jeckle::Request).to receive(:run).and_return(fake_request)
        results = FakeResource.search(query)

        expect(results).to match []
      end
    end
  end
end
