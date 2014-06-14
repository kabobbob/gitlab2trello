require 'sinatra/base'

require_relative 'helpers'
require_relative 'routes/auth.rb'
require_relative 'routes/api.rb'

class Gitlab2TrelloApp < Sinatra::Base

  enable :sessions

  helpers Sinatra::Gitlab2TrelloApp::Helpers

  register Sinatra::Gitlab2TrelloApp::Routing::Auth
  register Sinatra::Gitlab2TrelloApp::Routing::Api

  attr_accessor :api_key, :api_secret, :db

  def initialize
    # load trello api credentials
    trello_creds = YAML.load_file File.expand_path('../config/trello_creds.yml', __FILE__) rescue nil
    raise "Missing Trello credentials file" if trello_creds.nil?
    raise "Invalid Trello credentials file" if trello_creds == false

    @api_key = trello_creds['api_key']
    raise "Missing Trello API key" if @api_key.nil?

    @api_secret = trello_creds['api_secret']
    raise "Missing Trello API secret" if @api_secret.nil?

    @db = Sequel.sqlite
    @db.create_table :users do
      primary_key :id
      Integer :user_id
      String :key
      String :secret
    end

    # continue
    super
  end

  get '/' do
    erb :index
  end

  get '/test' do
    user = @db[:users].first
    tc = trello_client(user[:key], user[:secret])
    pp tc.find(:cards, 'R0di7FkV')
  end
end
