require 'spec_helper'

describe 'Gitlab2TrelloApp' do
  describe 'get /trello/request-token' do
    it "should be a redirect" do
      get '/trello/request-token'
      expect(last_response.status).to eq(302)
    end
  end

  pending 'get /trello/access-token' do
  end
end
