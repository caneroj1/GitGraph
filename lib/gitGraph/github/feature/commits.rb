require 'octokit'
require 'set'
require_relative '../graphable_data'

def commits(client)
  # dates will be the array that will be merged from all of the dates for each
  # commit in order to form the x-axis labels
  dates = Set.new

  # datasets will hold the data that we obtain for each repository
  # and their commits
  datasets = []

  client.each_repo do |repo|
    new_dataset = {
      label: repo,
      data: {}
    }

    client.commits(repo)
    last_response = client.last_response
    loop do
      last_response.data.each do |data|
        date = data[:commit][:author][:date].strftime('%-m/%d/%Y')
        dates.add(date)
        new_dataset[:data][date] ||= 0
        new_dataset[:data][date] += 1
      end

      break if last_response.rels[:next].nil?
      last_response = last_response.rels[:next].get
    end

    datasets.push(new_dataset)
  end

  # now we need to go through all of the dates, and check
  # the data for each dataset. if the date is not present
  # in the dataset, we add it with a value of 0
  dates.each do |date|
    datasets.each do |dataset|
      dataset[:data][date] = 0 unless dataset[:data].has_key?(date)
    end
  end

  # convert each dataset's data to an array
  datasets.each { |dataset| dataset[:data] = dataset[:data].to_a }

  # sort on the array by key
  datasets.each { |dataset| dataset[:data].sort! do |a, b|
    Time.new(a[0]) <=> Time.new(b[0])
  end }

  # convert the dates set into a sorted array
  dates = dates.to_a.sort { |a, b| Time.new(a) <=> Time.new(b) }

  # return a new graphable data item
  GitGraph::GitHub::GraphableData.new(labels: dates, datasets: datasets)
end
