require 'sinatra/base'

class Gitlab2TrelloApp < Sinatra::Base

  def trello_comment(author, repo, repo_url, branch, branch_url, git_hash, git_hash_url, comment)
    #  '''\[**%s** has a new commit about this card\]
    #\[repo: [%s](%s) | branch: [%s](%s) | hash: [%s](%s)\]
    #----
    #%s'''
  end

  get '/' do
    200
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
