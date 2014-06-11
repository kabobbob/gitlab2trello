ENV['RACK_ENV'] ||= 'development'

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'json'
require 'net/http'
require 'pp'

require './gitlab2trello_app.rb'
