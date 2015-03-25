require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::Client do
  before(:each) do
    GitGraph::Configuration.config do |config|
        config.username = ENV["username"]
        config.password = ENV["password"]
    end
  end

  let(:username) { ENV["username"] }

  context 'attributes' do
    let(:instance_methods) { GitGraph::GitHub::Client.instance_methods }

    it 'should have a getter for the github client' do
      expect(instance_methods).to include(:client)
    end
  end

  let(:client) { GitGraph::GitHub::Client.new(GitGraph::Configuration) }

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
  end

  context 'instance methods' do
    it 'can get a user by a key' do
      expect(client.get_user(username).login).to eq(username)
    end

    it 'aliases get' do
      expect(client[username].login).to eq(username)
    end

    it 'can add a new github user by key' do
      expect{ client.add_user(ENV["testname"]) }.to change(client, :user_count).by 1
    end

    it 'aliases store' do
      expect { client << ENV["testname"] }.to change(client, :user_count).by 1
    end
  end
end
