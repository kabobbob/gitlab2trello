require 'sinatra/base'

class Gitlab2TrelloApp < Sinatra::Base
  include Addressable
  include Trello
  include Trello::Authorization

  enable :sessions

  attr_accessor :api_key, :api_secret, :token_key, :token_secret

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

  def trello_comment(author, repo, repo_url, branch, branch_url, git_hash, git_hash_url, comment)
    #  '''\[**%s** has a new commit about this card\]
    #\[repo: [%s](%s) | branch: [%s](%s) | hash: [%s](%s)\]
    #----
    #%s'''
  end

  get '/' do
    session.delete(:request_token)
    erb :index
  end

  get '/trello_auth' do
    OAuthPolicy.consumer_credential = OAuthCredential.new @api_key, @api_secret
    OAuthPolicy.return_url = "http://themcclellanclan.homeip.net:4567/post_auth"
    OAuthPolicy.callback = Proc.new do |request_token|
      session[:request_token] = request_token

      # add trello params for authorization
      uri = URI.parse(request_token.authorize_url)
      q = URI.form_unencode(uri.query)
      q.push(["name", "CQS Gitlab2Trello"])
      #q.push(["expiration", "never"])
      q.push(["expiration", "1day"])
      q.push(["scope", "read,write"])
      uri.query = URI.form_encode(q)

      # redirect
      redirect uri
    end

    OAuthPolicy.authorize(nil)
  end

  get '/post_auth' do
    # build access token request
    OAuthPolicy.consumer_credential = OAuthCredential.new @api_key, @api_secret
    OAuthPolicy.token = OAuthCredential.new session[:request_token].token, session[:request_token].secret
    access_token_request = Request.new(
      :get,
      URI.parse("https://trello.com/1/OAuthGetAccessToken?oauth_verifier=#{params["oauth_verifier"]}")
    )

    # execute request
    response = Trello::TInternet.execute OAuthPolicy.authorize(access_token_request)

    # parse out token and secret
    matchdata = /oauth_token=([^&]+)&oauth_token_secret=(.+)/.match response.body
    user_token = OAuthCredential.new *matchdata[1..2]

    client = Trello::Client.new(
      consumer_key: @api_key,
      consumer_secret: @api_secret,
      oauth_token: user_token.key,
      oauth_token_secret: user_token.secret
    )

    pp client.find(:cards, 'R0di7FkV')
  end

  get '/add_comment' do
    #pp client.find(:cards, 'R0di7FkV')
  end

  post '/gl_system' do
    post = env['rack.input'].read
    data = JSON.parse(post) rescue nil
    pp data
    status 200
  end

  post '/push-events' do
    # get post data
    post = env['rack.input'].read
    if post.empty?
      status 400
    else
      data = JSON.parse(post) rescue nil
      if data.nil?
        status 406
      else
        pp data["commits"]
        status 200
      end
    end
  end
end
