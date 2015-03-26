require 'color-generator'

module GitGraph
  module GitHub
    class GraphableData
      attr_accessor :labels, :datasets

      # datasets should be an array of hashes. each has needs to contain
      # a label => name key-value pair, which is basically the name of that dataset, and
      # and a data => data_arr key-value pair, which is just an array of data points.
      def initialize(labels: labels, datasets: datasets)
        @labels, @datasets = labels, datasets
      end


      def stringify(chart_type, options = {})
        map_colors_to_datasets(format_options(options))
        if chart_type == :polar_area
          format_for_polar_area
        else
          format
        end
      end

      def map_colors_to_datasets(options)
        @datasets.map! { |dataset| dataset.merge(prettify(options)) }
      end

      def prettify(options)
        prettified_hash = {}
        base_color = ColorGenerator.new(saturation: 1.0, value: 1.0).create_rgb

        fill_color = new_color(base_color, options[:fill_alpha])
        stroke_color = new_color(base_color, options[:stroke_alpha])
        { :fillColor => fill_color, :strokeColor => stroke_color, :pointColor => stroke_color }
      end

      def new_color(color, alpha)
        "rgba(#{color[0]}, #{color[1]}, #{color[2]}, #{alpha})"
      end

      def format_options(options)
        options[:fill_alpha] ||= 0.2
        options[:stroke_alpha] ||= 0.1
        options
      end
    end
  end
end
