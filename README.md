# GitGraph

Displays nice graphs of GitHub usage through a Rack App. Can help you analyze things like what languages you most frequently push in, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitGraph'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitGraph

## Usage

```ruby
require 'gitGraph'

# configuring the client
GitGraph::Configuration.config do |config|
  config.username = # your github username
  config.password = # your github password
end

# your GitGraph client is now all configured to access GitHub's apis
client = GitGraph::GitHub::Client.new

# start adding GitHub users
client << # some github username

client + # another github username

# you can also github users using integers.
## CAUTION: these are not guaranteed to exist. ##

client + 1

# let's run a language comparison. this checks all of
# the public repositories for each added user and tallies
# up their language usage.
client.compare_languages(:radar) # using a radar chart

# we can change to a bar chart
# the compare languages feature is indexed under
# the :languages key.
client.change_chart_type(:languages, :bar)

# let's render our chart
path = # path to where you want the chart
client.render(path)

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gitGraph/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
