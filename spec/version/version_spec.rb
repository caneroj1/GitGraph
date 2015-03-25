require_relative '../spec_helper.rb'

describe GitGraph do
  it 'should have a version' do
    expect(GitGraph::VERSION).to_not be_nil
  end
end
