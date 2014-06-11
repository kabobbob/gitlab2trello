require 'spec_helper'

describe 'Gitlab2TrelloApp' do
  def app
    @app ||= Gitlab2TrelloApp
  end

  describe 'get /' do
    it "should be a valid route" do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

  describe 'get /trello_auth' do
    it "should be a valid route" do
      get '/trello_auth'
      expect(last_response).to be_ok
    end
  end

  describe 'post /push-events' do
    context "invalid post" do
      it "should error when no data is posted" do
        post '/push-events'
        expect(last_response.status).to eq(400)
      end

      it "should error when non-json data is posted" do
        post '/push-events', {body: "cat"}
        expect(last_response.status).to eq(406)
      end
    end
  end
end
