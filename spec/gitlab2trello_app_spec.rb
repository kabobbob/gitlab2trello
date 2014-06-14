require 'spec_helper'

describe 'Gitlab2TrelloApp' do
  describe 'get /' do
    it "should be a valid route" do
      get '/'
      expect(last_response.status).to eq(200)
    end
  end

end
