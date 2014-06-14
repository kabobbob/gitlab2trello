module Sinatra
  module Gitlab2TrelloApp
    module Helpers

      include Trello

      def trello_client(key, secret)
        Trello::Client.new(
          consumer_key: @api_key,
          consumer_secret: @api_secret,
          oauth_token: key,
          oauth_token_secret: secret
        )
      end
    end
  end
end
