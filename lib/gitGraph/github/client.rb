require 'octokit'
require_relative '../configuration'
require_relative 'graphable_object'
require_relative 'feature'
require_relative '../renderer.rb'

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

        @data_to_graph = {}
      end

      def get_user(key)
        @stored_users.fetch(key)
      end
      alias_method :[], :get_user

      def add_user(user)
        user_to_add = @client.user(user)
        @stored_users[user_to_add.login] = user_to_add
      end
      alias_method :<<, :add_user
      alias_method :+, :add_user

      def remove_user(user)
        @stored_users.delete(user)
      end
      alias_method :-, :remove_user

      def user_count
        @stored_users.count
      end
      alias_method :user_size, :user_count

      def change_chart_type(graphable_object_name, chart_type)
        @data_to_graph[graphable_object_name].chart_type = chart_type
      end

      def each
        @stored_users.each { |name, user| yield(name, user) }
      end

      def compare_languages(chart, **options)
        options ||= {}
        title = options.delete(:title) || "Kilobytes Written per Language"
        data = GitGraph::GitHub::Feature.send(:compare_languages, self)
        graphable = GitGraph::GitHub::GraphableObject.new(data, chart, options, title)
        @data_to_graph[:languages] = graphable
      end

      def render(path)
        @data_to_graph.each { |key, data| GitGraph::Renderer.render(data, key, path) }
        GitGraph::Renderer.copy_files(path)
      end
    end
  end
end
