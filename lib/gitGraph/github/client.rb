require 'octokit'

module GitGraph
  module GitHub
    class Client
      attr_reader :client

      def initialize(configuration)
        @client = Octokit::Client.new(
          login:    configuration.username,
          password: configuration.password
        )
      end
    end
  end
end
