module GitGraph
  module GitHub
    class User
      attr_reader :username

      def initialize(name)
        @username = name
      end
    end
  end
end
