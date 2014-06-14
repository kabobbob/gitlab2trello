require 'spec_helper'

describe 'Gitlab2TrelloApp' do
  pending '#trello_client' do
  end

  pending 'post /gitlab/system-event' do
  end

  describe 'post /gitlab/push-event' do
    context "invalid post" do
      it "should error when no data is posted" do
        post '/gitlab/push-event'
        expect(last_response.status).to eq(400)
      end

      it "should error when non-json data is posted" do
        post '/gitlab/push-event', {body: "cat"}
        expect(last_response.status).to eq(406)
      end
    end
  end
end
