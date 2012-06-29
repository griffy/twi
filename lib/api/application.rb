# TODO: For some reason, requests that generate errors on
#       the server result in the server sending back HTML
#       despite content-type request. Granted, when the
#       server is actually in production mode we won't be
#       sending back errors to begin with, but this is still
#       annoying.

require 'api'

module API
  class Application < Grape::API
    version 'v1', :using => :header, :vendor => '1393designs'
    # TODO: without this here, the API seems to ignore
    #       Accept headers specifying json as return format
    default_format :json

    represent OAuth2::Model::Authorization, :with => API::Entities::Authorization
    represent User, :with => API::Entities::User
    represent Snippet, :with => API::Entities::Snippet

    helpers API::Helpers::All

    # Modeled after Github's Non-Webapp Flow :)
    resource :authorizations do
      # All auth routes require Basic Authentication
      http_basic do |email, password|
        User.authenticate(email, password)
      end

      get do
        auths = current_user.oauth2_authorizations
        present_all! auths
      end

      get '/:id' do
        auth = current_user.oauth2_authorizations.find_by_id(params[:id])
        unless auth
          error! 'Invalid authorization id'
        end
        present! auth
      end

      post do
        unless params.include? :client_id
          error! 'No client id provided'
        end

        client = OAuth2::Model::Client.find_by_client_id(params[:client_id])
        unless client
          error! 'Invalid client id'
        end

        # give all permissions if none specified
        unless params.include? :scope
          params[:scope] = 'access_all'
        end

        puts current_user.email

        auth = OAuth2::Model::Authorization.for_response_type('token',
          :owner => current_user,
          :client => client,
          :scope => params[:scope]
        ) # :duration => ?

        unless auth
          error! 'Unable to create authorization'
        end

        present! auth
      end

      delete '/:id' do
        auth = current_user.oauth2_authorizations.find_by_id(params[:id])
        unless auth
          error! 'Invalid authorization id'
        end
        auth.destroy

        status 204
      end
    end

    resource :users do
      get 
    end

    resource :snippets do # per-user
      get do
        can 'read_snippets'
        present_all! current_user.snippets
      end

      put do
        can 'write_snippets'
        # replace all user's snippets with these new ones
      end
    
      post do
        can 'write_snippets'

        unless params.include? :title
          error! 'No title provided'
        end

        unless params.include? :content
          error! 'No content provided'
        end

        unless params.include? :visibility
          error! 'No visibility provided'
        end

        # create a new snippet
        snippet = Snippet.new(:title => params[:title],
                              :content => params[:content],
                              :visibility => params[:visibility])
        snippet.user_id = current_user.id

        unless snippet.save
          error! 'Unable to create snippet'
        end

        present! snippet
      end

      delete do
        can 'delete_snippets'

        current_user.snippets.destroy

        # delete all the user's snippets
      end

      get '/:id' do
        can 'read_snippets'
        # return a specific snippet according to 
        # requested MIME type

        # something like Snippet.find(params[:id])
        # where we also narrow down by user
      end

      put '/:id' do
        can 'write_snippets'
        # update the snippet with this new one
        # or create a new one altogether at this URI
      end

      post '/:id' do
        can 'write_snippets'
        # this might be useful if we want to create
        # snippets that belong to a parent snippet
        # ie, 'folder'
      end

      delete '/:id' do
        can 'delete_snippets'

        unless params.include? :id
          error! 'No id provided'
        end

        # delete this snippet
        snippet = current_user.snippets.find_by_id(params[:id])
        snippet.destroy
      end
    end
  end
end