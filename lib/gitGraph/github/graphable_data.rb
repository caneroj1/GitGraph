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
        new_options = format_options(options)
        map_colors_to_datasets(new_options)
        if chart_type == :polar_area
          format_for_polar_area(new_options)
        else
          format_chart(new_options)
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
        { :fillColor => fill_color, :strokeColor => stroke_color, :pointColor => stroke_color,
          :pointStrokeColor => options[:point_stroke_color], :pointHighlightFill => options[:point_highlight_fill],
          :pointHighlightStroke => stroke_color }
      end

      def new_color(color, alpha)
        "rgba(#{color[0]}, #{color[1]}, #{color[2]}, #{alpha})"
      end

      def format_options(options)
        options[:fill_alpha] ||= 0.2
        options[:stroke_alpha] ||= 1.0
        options[:point_stroke_color] ||= '#fff'
        options[:point_highlight_fill] ||= '#fff'
        options
      end

      private
      def format_chart(new_options)
        main_string = make_options(new_options)
        main_string << "\nvar data = {\n"
        main_string << make_labels
        main_string << make_datasets
        main_string << "\n};"
      end

      def make_options(new_options)
        options_string = "var options = {\n"
        opts_arr = []

        new_options.each do |key, value|
          if value.class.eql?(String)
            opts_arr.push("\t#{key}: '#{value}'")
          else
            opts_arr.push("\t#{key}: #{value}")
          end
        end

        options_string << opts_arr.join(",\n")
        options_string << "\n};"
        options_string
      end

      def make_labels
        "\tlabels: #{@labels.map { |label| label.to_s }.inspect},\n"
      end

      def make_datasets
        main_string = "\tdatasets: ["
        dataset_string_array = []

        @datasets.each do |dataset|
          new_string = "\n\t\t{\n"
          dataset_string_components = []

          dataset.each_pair do |key, value|
            value = value.class.eql?(String) ? "\"#{value}\"" : value.map { |item| [item[1]]}
            dataset_string_components.push("\t\t\t#{key}: #{value}")
          end

          new_string << dataset_string_components.join(",\n")
          new_string << "\n\t\t}"

          dataset_string_array.push(new_string)
        end

        main_string << dataset_string_array.join(',')
        main_string << "\n\t]"
      end
    end
  end
end
