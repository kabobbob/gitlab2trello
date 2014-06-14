module Sinatra
  module Gitlab2TrelloApp
    module Routing
      module Auth

        include Addressable
        include Trello
        include Trello::Authorization

        def self.registered(app)
          # request a token for a user from trello
          request_token = lambda do
            OAuthPolicy.consumer_credential = OAuthCredential.new @api_key, @api_secret
            OAuthPolicy.return_url = "http://themcclellanclan.homeip.net:4567/trello/access-token"
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

          # get access token for user
          access_token = lambda do
            # build access token request
            OAuthPolicy.consumer_credential = OAuthCredential.new @api_key, @api_secret
            OAuthPolicy.token = OAuthCredential.new session[:request_token].token, session[:request_token].secret
            access_token_request = Trello::Request.new(
              :get,
              URI.parse("https://trello.com/1/OAuthGetAccessToken?oauth_verifier=#{params["oauth_verifier"]}")
            )

            # execute request
            response = Trello::TInternet.execute OAuthPolicy.authorize(access_token_request)

            # parse out token and secret
            matchdata = /oauth_token=([^&]+)&oauth_token_secret=(.+)/.match response.body
            user_token = OAuthCredential.new *matchdata[1..2]

            #TODO update user info in db
            #users = @db[:users]
            #users.insert(user_id: 1, key: user_token.key, secret: user_token.secret)

            status 200
          end

          app.get '/trello/request-token', &request_token
          app.get '/trello/access-token', &access_token
        end
      end
    end
  end
end
