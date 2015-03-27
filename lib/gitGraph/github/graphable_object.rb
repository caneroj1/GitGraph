require_relative 'graphable_data'

module GitGraph
  module GitHub
    class GraphableObject
      attr_accessor :changed, :data, :chart_type, :options
      attr_reader :chart_string

      # data should be a graphable data object
      def initialize(data, chart_type = nil, options = {})
        @data = check_data_param(data)
        @options = options
        @changed = true
        @chart_type = chart_type || :line
      end

      def chart_type=(chart_type)
        @chart_type = chart_type
        @changed = true
      end

      def data=(data)
        @data = check_data_param(data)
        @changed = true
      end

      def options=(options)
        @options = options
        @changed = true
      end

      def chart_type_to_string
        case @chart_type
        when :line
          "Line"
        when :radar
          "Radar"
        when (:donut) || (:doughnut)
          "Doughnut"
        when :polar_area
          "PolarArea"
        when :bar
          "Bar"
        end
      end

      def stringify
        @chart_string = @data.stringify(@chart_type, @options)
      end

      private
      def check_data_param(data)
        type = GitGraph::GitHub::GraphableData
        if !data.nil? && data.class != type
          raise ArgumentError, "The passed in data should be an object of type: #{type}."
        end
        data
      end
    end
  end
end
