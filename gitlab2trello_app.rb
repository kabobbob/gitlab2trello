require 'sinatra/base'

require_relative 'helpers'
require_relative 'models'
require_relative 'routes/auth.rb'
require_relative 'routes/api.rb'

class Gitlab2TrelloApp < Sinatra::Base

  enable :sessions

  helpers Sinatra::Gitlab2TrelloApp::Helpers

  register Sinatra::Gitlab2TrelloApp::Routing::Auth
  register Sinatra::Gitlab2TrelloApp::Routing::Api

  attr_accessor :api_key, :api_secret

  def initialize
    # load trello api credentials
    trello_creds = YAML.load_file File.expand_path('../config/trello.yml', __FILE__) rescue nil
    raise "Missing Trello credentials file" if trello_creds.nil?
    raise "Invalid Trello credentials file" if trello_creds == false

    @api_key = trello_creds['api_key']
    raise "Missing Trello API key" if @api_key.nil?

    @api_secret = trello_creds['api_secret']
    raise "Missing Trello API secret" if @api_secret.nil?

    @callback_url = trello_creds['callback_url']
    raise "Missing Trello callback url" if @callback_url.nil?

    @app_name = trello_creds['app_name']
    raise "Missing Trello app name" if @app_name.nil?

    @expiration = trello_creds['expiration']
    raise "Missing Trello expiration" if @expiration.nil?

    @scope = trello_creds['scope']
    raise "Missing Trello scope" if @scope.nil?

    # continue
    super
  end

  get '/' do
    erb :index
  end

  # tmp routes
  get '/test' do
    user = User.first
    tc = trello_client(user[:key], user[:secret])
    pp tc.find(:cards, 'R0di7FkV')
  end
end
