require 'dotenv'
require_relative '../lib/gitGraph'
Dotenv.load

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
