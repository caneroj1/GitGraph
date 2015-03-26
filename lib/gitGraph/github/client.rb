require 'octokit'
require_relative '../configuration'
require_relative 'graphable_object'

module GitGraph
  module GitHub
    class Client
      attr_reader :client
      include Enumerable

      def initialize
        @client = Octokit::Client.new(
          login:    GitGraph::Configuration.username,
          password: GitGraph::Configuration.password
        )

        @stored_users = {
          GitGraph::Configuration.username =>
          @client.user
        }
      end

      def get_user(key)
        @stored_users.fetch(key)
      end
      alias_method :[], :get_user

      def add_user(user)
        @stored_users[user] = @client.user user
      end
      alias_method :<<, :add_user

      def user_count
        @stored_users.count
      end
      alias_method :user_size, :user_count

      def each
        @stored_users.each { |name, user| yield(name, user) }
      end
    end
  end
end
