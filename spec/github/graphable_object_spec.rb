require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::GraphableObject do
  let(:data) { GitGraph::GitHub::GraphableData.new(labels: nil, datasets: nil) }

  context 'attributes' do
    let(:graphable) { GitGraph::GitHub::GraphableObject.new(data, nil, nil, "title") }

    it 'accepts options' do
      expect(graphable.options).to be_nil
    end

    it 'has a title' do
      expect(graphable.title).to eq("title")
    end

    it 'can change the title' do
      graphable.title = "new"
      expect(graphable.title).to eq("new")
    end

    it 'has a default changed attribute' do
      expect(graphable.changed).to eq(true)
    end

    it 'should have a data object' do
      expect(graphable.data).to eq(data)
    end

    it 'should have a default chart type' do
      expect(graphable.chart_type).to eq(:line)
    end

    it 'should be able change the chart type' do
      graphable.chart_type = :radar
      expect(graphable.chart_type).to eq(:radar)
    end

    it 'should raise an error if the data is not of graphable object type' do
      expect{ GitGraph::GitHub::GraphableObject.new(10) }.to raise_error(ArgumentError)
    end
  end

  context 'changing chart type' do
    let(:graphable) { GitGraph::GitHub::GraphableObject.new(data, nil, nil, nil) }

    it 'should mark the object as changed' do
      graphable.changed = false
      graphable.chart_type = :line
      expect(graphable.changed).to eq(true)
    end
  end
end
