require_relative 'graphable_data'

module GitGraph
  module GitHub
    class GraphableObject
      attr_accessor :changed, :data

      # data should be a graphable data object or nil
      def initialize(data = nil)
        check_data_param(data)
        @data = data
      end

      private
      def check_data_param(data)
        type = GitGraph::GitHub::GraphableData
        if !data.nil? && data.class != type
          raise ArgumentError, "The passed in data should be an object of type: #{type}."
        end
      end
    end
  end
end
