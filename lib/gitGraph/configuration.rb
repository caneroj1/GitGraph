module GitGraph
  class Configuration
    class << self
      attr_accessor :username, :password

      def config
        raise ArgumentError, block_error if !block_given?
        yield self
      end

      def block_error
        "A block must be passed in order to set attributes."
      end
    end
  end
end
