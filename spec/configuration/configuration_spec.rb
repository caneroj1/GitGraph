require_relative '../spec_helper.rb'

RSpec.describe GitGraph::Configuration do
  context 'attributes' do
    let(:method_list) { GitGraph::Configuration.methods }

    it 'should have a setter for username' do
      expect(method_list).to include(:username=)
    end

    it 'should have a getter for username' do
      expect(method_list).to include(:username)
    end

    it 'should have a setter for password' do
      expect(method_list).to include(:password=)
    end

    it 'should have a getter for password' do
      expect(method_list).to include(:password)
    end

    it 'should have a setter for access token' do
      expect(method_list).to include(:access_token=)
    end

    it 'should have a getter for access token' do
      expect(method_list).to include(:access_token)
    end
  end

  context 'configuring' do
    it 'needs a block' do
      expect{ GitGraph::Configuration.config }.to raise_error(ArgumentError)
    end

    context 'execution without access token' do
      before(:each) do
        GitGraph::Configuration.config do |config|
          config.username = "username"
          config.password = "password"
        end
      end

      it 'should set the username' do
        expect(GitGraph::Configuration.username).to eq("username")
      end

      it 'should set the password' do
        expect(GitGraph::Configuration.password).to eq("password")
      end

      it 'should have a nil access token' do
        expect(GitGraph::Configuration.access_token).to be_nil
      end
    end

    context 'execution with access token' do
      before(:each) do
        GitGraph::Configuration.config do |config|
          config.username = "username"
          config.password = "password"
          config.access_token = "access token"
        end
      end

      it 'should set the username' do
        expect(GitGraph::Configuration.username).to eq("username")
      end

      it 'should set the password' do
        expect(GitGraph::Configuration.password).to eq("password")
      end

      it 'should set the access token' do
        expect(GitGraph::Configuration.access_token).to eq("access token")
      end
    end
  end
end
