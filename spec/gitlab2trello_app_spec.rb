require 'spec_helper'
require_relative '../gitlab2trello_app.rb'

describe 'gitlab2trello_app' do
  def app
    Sinatra::Application
  end

  describe 'post /push-events' do
    it "should allow posting to 'push-events'" do
      post '/push-events'
      expect(last_response).to be_ok
    end
  end
end
