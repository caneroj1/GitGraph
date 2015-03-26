require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::GraphableObject do
  context 'attributes' do
    let(:graphable) { GitGraph::GitHub::GraphableObject.new }

    it 'has a changed attribute' do
      expect(graphable.changed).to be_nil
    end

    it 'should have a data object' do
      expect(graphable.data).to be_nil
    end

    it 'should raise an error if the data is not of graphable object type' do
      expect{ GitGraph::GitHub::GraphableObject.new(10) }.to raise_error(ArgumentError)
    end
  end
end
