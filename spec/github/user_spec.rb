require_relative '../spec_helper'

RSpec.describe GitGraph::GitHub::User do
  context 'attributes' do
    let(:user) { GitGraph::GitHub::User.new(ENV["username"]) }

    it 'should have a getter for username' do
      expect(user.username).to eq(ENV["username"])
    end
  end
end
