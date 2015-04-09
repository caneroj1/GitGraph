require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::Client do
  before(:each) do
    GitGraph::Configuration.config do |config|
        config.username = ENV["username"]
        config.password = ENV["password"]
        config.access_token = ENV["access_token"]
    end
  end

  let(:username) { ENV["username"] }

  context 'attributes' do
    let(:instance_methods) { GitGraph::GitHub::Client.instance_methods }

    it 'should have a getter for the github client' do
      expect(instance_methods).to include(:client)
    end
  end

  let(:client) { GitGraph::GitHub::Client.new }

  context 'initialization' do

    it 'should be able to initialize with a good configuration' do
      expect(client.client.class).to eq(Octokit::Client)
    end

    it 'should create a user storing the user that it was initialized with' do
      expect(client.get_user(username).login).to eq(username)
    end

    it 'should only create one user when initialized' do
      expect(client.user_count).to eq(1)
    end

    it 'should have an access token' do
      expect(client.client.access_token).to_not be_nil
    end
  end

  context 'instance methods' do
    it 'can get a user by a key' do
      expect(client.get_user(username).login).to eq(username)
    end

    it 'aliases get with []' do
      expect(client[username].login).to eq(username)
    end

    it 'can add a new github user by key' do
      expect { client.add_user(ENV["testname"]) }.to change(client, :user_count).by 1
    end

    it 'can add a new github user by number' do
      expect(client.add_user(1).login).to_not eq("")
    end

    it 'aliases store with <<' do
      expect { client << ENV["testname"] }.to change(client, :user_count).by 1
    end

    it 'aliases store with +' do
      expect { client + ENV["testname"] }.to change(client, :user_count).by 1
    end

    it 'can remove a github user' do
      expect { client.remove_user(ENV["username"]) }.to change(client, :user_count).by -1
    end

    it 'aliases remove with -' do
      expect { client - ENV["username"] }.to change(client, :user_count).by -1
    end

    specify { expect { |block| client.each(&block) }.to yield_control }

    it 'can compare languages' do
    end

    it 'can return the number of repos stored' do
      expect(client.repo_count).to eq(0)
    end

    it 'aliases the number of repos stored' do
      expect(client.repo_size).to eq(0)
    end

    context 'repository functionality' do
      before(:each) do
        client.add_repo('caneroj1/GitGraph')
      end

      it 'has repositories' do
        expect(client.repo_count).to eq(1)
      end

      specify { expect { |block| client.each_repo(&block) }.to yield_control }

      it 'can store a repository name' do
        expect { client.add_repo('caneroj1/GitGraph') }.to change(client, :repo_count).by 1
      end

      it 'can remove a repository' do
        expect { client.remove_repo('caneroj1/GitGraph') }.to change(client, :repo_count).by -1
      end
    end
  end
end
