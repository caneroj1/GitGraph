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
          login:        GitGraph::Configuration.username,
          password:     GitGraph::Configuration.password,
          access_token: GitGraph::Configuration.access_token
        )

        @stored_users = {
          GitGraph::Configuration.username =>
          @client.user
        }

        @data_to_graph = {}
        @repos = []
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

      def add_repo(repo_name)
        @repos.push(repo_name)
      end

      def remove_user(user)
        @stored_users.delete(user)
      end
      alias_method :-, :remove_user

      def remove_repo(repo_name)
        @repos.delete(repo_name)
      end

      def user_count
        @stored_users.count
      end
      alias_method :user_size, :user_count

      def repo_count
        @repos.count
      end
      alias_method :repo_size, :repo_count

      def change_chart_type(graphable_object_name, chart_type)
        @data_to_graph[graphable_object_name].chart_type = chart_type
      end

      def each
        @stored_users.each { |name, user| yield(name, user) }
      end

      def each_repo
        @repos.each { |repo| yield(repo) }
      end

      def compare_languages(chart, **options)
        options ||= {}
        title = options.delete(:title) || "Kilobytes Written per Language"
        data = GitGraph::GitHub::Feature.send(:compare_languages, self)
        graphable = GitGraph::GitHub::GraphableObject.new(data, chart, options, title)
        @data_to_graph[:languages] = graphable
      end

      def commits(**options)
        options ||= {}
        title = options.delete(:title) || "Commits per Day"
        data = GitGraph::GitHub::Feature.send(:commits, self)
        graphable = GitGraph::GitHub::GraphableObject.new(data, :line, options, title)
        @data_to_graph[:commits] = graphable
      end

      def issues(**options)
        options ||= {}

        title1 = options.delete(:title_for_issues_by_date) || "Issues by Date"
        title2 = options.delete(:title_for_issue_types) || "Issues by Type"
        chart1 = options.delete(:chart_for_issue_dates) || :line
        chart2 = options.delete(:chart_for_issue_types) || :bar

        data_items = GitGraph::GitHub::Feature.send(:issues, self)

        data_items.each_with_index do |item, index|
          title = eval local_variables[local_variables.find_index("title#{index+1}".to_sym)].to_s
          chart = eval local_variables[local_variables.find_index("chart#{index+1}".to_sym)].to_s
          
          graphable = GitGraph::GitHub::GraphableObject.new(item, chart, options, title)
          @data_to_graph["issues#{index + 1}".to_sym] = graphable
        end
      end

      def render(path)
        @data_to_graph.each { |key, data| GitGraph::Renderer.render(data, key, path) }
        GitGraph::Renderer.copy_files(path)
      end
    end
  end
end
