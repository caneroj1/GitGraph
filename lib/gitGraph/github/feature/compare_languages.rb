require 'octokit'
require_relative '../graphable_data'

def compare_languages(client)
  # languages will be the array that will be used
  # to form labels in the chart
  languages = []

  # datasets will hold the data that we obtain for each user
  # based on github querying for their languages
  datasets = []

  client.each do |name, user|
    new_dataset = {
      label: name,
      data: {}
    }

    client.client.repositories(name).each do |repo|
      client.client.languages(repo.full_name).attrs.each_pair do |lang, value|
        languages.push(lang) unless languages.include?(lang)
        new_dataset[:data][lang] ||= 0
        new_dataset[:data][lang] += value
      end
    end

    datasets.push(new_dataset)
  end

  # sort the languages
  languages.sort!

  # go through the languages, and if a dataset does not have that language
  # as part of its data array, default it to 0
  languages.each do |lang|
    datasets.each { |dataset| dataset[:data][lang] ||= 0}
  end

  # convert the data hash to an array
  datasets.each { |dataset| dataset[:data] = dataset[:data].to_a }

  # sort on the array by key
  datasets.each { |dataset| dataset[:data].sort! { |a, b| a[0] <=> b[0] } }

  # each value in the array represents bytes of code written in a language.
  # convert each value in the array to kilobytes written in each language
  datasets.each { |dataset| dataset[:data].each { |data| data[1] /= 1024} }

  # return a new graphable data item
  GitGraph::GitHub::GraphableData.new(labels: languages, datasets: datasets)
end
