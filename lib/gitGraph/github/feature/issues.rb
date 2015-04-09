require 'octokit'
require_relative '../graphable_data'

def issues(client)
  # dates will be the array that will hold all of the dates for each
  # commit in order to form the x-axis labels
  dates = Set.new

  # types will be the array that will hold all of the issue types for
  # each issue in order to form the x-axis labels
  types = Set.new

  # dataset_issues_per_day will hold the data that we obtain for each repository
  # and their commits
  dataset_issues_per_day = []

  # dataset_issue_types will hold the types of each issue and will function
  # as the labels
  dataset_issue_types = []

  client.each_repo do |repo|
    new_dataset_per_day = {
      label: repo,
      data: {}
    }

    new_dataset_issue_type = {
      label: repo,
      data: {}
    }

    client.client.issues(repo)
    last_response = client.client.last_response
    loop do
      last_response.data.each do |data|
        date = data[:created_at].strftime('%-m/%d/%Y')
        dates.add(date)
        new_dataset_per_day[:data][date] ||= 0
        new_dataset_per_day[:data][date] += 1

        data[:labels].each do |label_hash|
          new_dataset_issue_type[:data][label_hash[:name]] ||= 0
          new_dataset_issue_type[:data][label_hash[:name]] += 1
          types.add(label_hash[:name])
        end
      end

      break if last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
    end

    dataset_issue_types.push(new_dataset_issue_type)
    dataset_issues_per_day.push(new_dataset_per_day)
  end

  # now we need to go through all of the dates, and check
  # the data for each dataset. if the date is not present
  # in the dataset, we add it with a value of 0
  dates.each do |date|
    dataset_issues_per_day.each do |dataset|
      dataset[:data][date] = 0 unless dataset[:data].has_key?(date)
    end
  end

  # now we need to go through all of the types, and check
  # the data for each dataset. if the type is not present
  # in the dataset, we add it with a value of 0
  types.each do |type|
    dataset_issue_types.each do |dataset|
      dataset[:data][type] = 0 unless dataset[:data].has_key?(type)
    end
  end

  # convert each dataset's data to an array
  dataset_issues_per_day.each { |dataset| dataset[:data] = dataset[:data].to_a }
  dataset_issue_types.each { |dataset| dataset[:data] = dataset[:data].to_a }

  # sort on the array by key
  dataset_issues_per_day.each { |dataset| dataset[:data].sort! do |a, b|
    date_one = a[0].split('/')
    date_two = b[0].split('/')
    Time.new(date_one[2], date_one[0], date_one[1]) <=> Time.new(date_two[2], date_two[0], date_two[1])
  end }

  # sort each dataset alphabetically according to the issue type.
  dataset_issue_types.each { |dataset| dataset[:data].sort! { |a, b| a[0] <=> b[0] } }

  # convert the dates set into a sorted array
  dates = dates.to_a.sort do |a, b|
    date_one = a.split('/')
    date_two = b.split('/')
    Time.new(date_one[2], date_one[0], date_one[1]) <=> Time.new(date_two[2], date_two[0], date_two[1])
  end

  # sort the types
  types = types.to_a.sort

  # return an array of GraphableData items
  issues_per_day = GitGraph::GitHub::GraphableData.new(labels: dates, datasets: dataset_issues_per_day)
  issues_types = GitGraph::GitHub::GraphableData.new(labels: types, datasets: dataset_issue_types)
  [issues_per_day, issues_types]
end
