require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::Client do
  before(:each) do
    GitGraph::Configuration.config do |config|
        config.username = "caneroj1"
        config.password = ENV["password"]
    end
  end

  context 'attributes' do
    let(:instance_methods) { GitGraph::GitHub::Client.instance_methods }

    it 'should have a getter for the github client' do
      expect(instance_methods).to include(:client)
    end
  end

  it 'should be able to initialize with a good configuration' do
    expect(GitGraph::GitHub::Client.new(GitGraph::Configuration).client.class).to eq(Octokit::Client)
  end
end
