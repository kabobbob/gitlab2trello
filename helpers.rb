module Sinatra
  module Gitlab2TrelloApp
    module Helpers

      include Trello
      #include Trello::Authorization

      def trello_client(user_id)
        Trello::Client.new(
          consumer_key: @api_key,
          consumer_secret: @api_secret,
          oauth_token: user_token.key,
          oauth_token_secret: user_token.secret
        )
      end
    end
  end
end
