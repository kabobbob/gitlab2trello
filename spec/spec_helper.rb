ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'rack/test'
require 'rspec/autorun'
require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
end
