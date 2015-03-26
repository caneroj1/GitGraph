require_relative '../spec_helper.rb'

RSpec.describe GitGraph::GitHub::GraphableData do
  let(:labels) { %w{Test Test Test Test Test} }
  let(:dataset) { [{ label: "dataset_one", data: [1, 2, 3, 4, 5] }] }
  let(:data) { GitGraph::GitHub::GraphableData.new(labels: labels, datasets: dataset) }

  context 'attributes' do
    it 'should have a labels attribute' do
      expect(data.labels).to_not be_nil
    end

    it 'should have a datasets attribute' do
      expect(data.datasets).to_not be_nil
    end

    it 'should have a key called label in each individual dataset' do
      expect(data.datasets.first).to have_key(:label)
    end

    it 'should have a key called data in each individual dataset' do
      expect(data.datasets.first).to have_key(:data)
    end
  end

  context 'instance methods' do
    let(:options) { options = { fill_alpha: 0.2, stroke_alpha: 1.0, :point_stroke_color=>"#fff", :point_highlight_fill=>"#fff"} }
    let(:color)   { ColorGenerator.new(saturation: 1.0, value: 1.0).create_rgb }

    it 'should be able to generate a random rgba string' do
      expect(data.new_color(color, 0.5)).to match(/rgba\([0-9]+, [0-9]+, [0-9]+, [0-9]+[.][0-9]+\)/)
    end

    it 'has defaults for the dataset color options' do
      expect(data.format_options({})).to eq(options)
    end

    it 'makes a nice hash to color a dataset with' do
      expect(data.prettify(options).class).to eq(Hash)
    end

    it 'prettification gives us a fill color' do
      expect(data.prettify(options)).to have_key(:fillColor)
    end

    it 'prettification gives us a stroke color' do
      expect(data.prettify(options)).to have_key(:strokeColor)
    end

    it 'prettification gives us a point color' do
      expect(data.prettify(options)).to have_key(:pointColor)
    end

    it 'merges prettified hash with the dataset hash' do
      data.map_colors_to_datasets(options)
      data.datasets.each { |dataset| expect(dataset).to have_key(:fillColor) }
    end
  end

  context 'making output for charts' do
    let(:datasets) {
      [
        { label: "Dataset One",
          data: [1, 2, 3, 4, 5]
        },
        {
          label: "Dataset Two",
          data: [6, 7, 8, 9, 10]
        },
        {
          label: "Dataset Three",
          data: [1, 6, 3, 7, 8]
        }
      ]
    }

    let(:labels) { %w{Test Test Test Test Test} }
    let(:data) { GitGraph::GitHub::GraphableData.new(labels: labels, datasets: datasets) }

    it 'should make a nice data block for line charts' do
      expect(data.stringify(:line)).to_not be_nil
    end

    it 'should make a nice data block for bar charts' do
      expect(data.stringify(:bar)).to_not be_nil
    end

    it 'should make a nice data block for radar charts' do
      expect(data.stringify(:radar)).to_not be_nil
    end

    it 'should make a nice data block for polar area charts'
  end
end
