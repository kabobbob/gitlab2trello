module Sinatra
  module Gitlab2TrelloApp
    module Routing
      module Api

        def trello_comment(author, repo, repo_url, branch, branch_url, git_hash, git_hash_url, comment)
          #  '''\[**%s** has a new commit about this card\]
          #\[repo: [%s](%s) | branch: [%s](%s) | hash: [%s](%s)\]
          #----
          #%s'''
        end

        def self.registered(app)
          system_event = lambda do
            post = env['rack.input'].read
            data = JSON.parse(post) rescue nil

            # process event
            case data["event_name"]
            when "user_create"
              pp data
              # add user to local db
              # email user link to trello auth
            else
            end
            status 200
          end

          push_event = lambda do
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
                #pp client.find(:cards, 'R0di7FkV')
                status 200
              end
            end
          end

          app.post '/gitlab/system-event', &system_event
          app.post '/gitlab/push-event', &push_event
        end
      end
    end
  end
end
