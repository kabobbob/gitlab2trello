ENV['RACK_ENV'] ||= 'test'

require File.expand_path(File.dirname(__FILE__) + '/../config/boot.rb')

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
end
