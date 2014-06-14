require 'sinatra/base'

require_relative 'helpers'
require_relative 'routes/auth.rb'
require_relative 'routes/api.rb'

class Gitlab2TrelloApp < Sinatra::Base

  enable :sessions

  register Sinatra::Gitlab2TrelloApp::Routing::Auth
  register Sinatra::Gitlab2TrelloApp::Routing::Api

  attr_accessor :api_key, :api_secret

  def initialize
    # load trello api credentials
    trello_creds = YAML.load_file File.expand_path('../config/trello_creds.yml', __FILE__) rescue nil
    raise "Missing Trello credentials file" if trello_creds.nil?
    raise "Invalid Trello credentials file" if trello_creds == false

    @api_key = trello_creds['api_key']
    raise "Missing Trello API key" if @api_key.nil?

    @api_secret = trello_creds['api_secret']
    raise "Missing Trello API secret" if @api_secret.nil?

    # continue
    super
  end

  get '/' do
    erb :index
  end

end
