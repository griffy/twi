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

    represent OAuth2::Model::Authorization, :with => API::Entities::Authorization
    represent User, :with => API::Entities::User
    represent Snippet, :with => API::Entities::Snippet

    helpers API::Helpers::Resource
    helpers API::Helpers::Model
    helpers API::Helpers::Auth

    # Modeled after Github's Non-Web App Flow :)
    resource :authorizations do
      # All auth routes require Basic Authorization
      http_basic do |email, password|
        @owner = User.authenticate(email, password)
      end

      get do
        auths = @owner.authorizations
        present_all! auths
      end

      get '/:id' do
        auth = @owner.authorizations.find(params[:id])
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
          params[:scope] = 'all'
        end

        # create a new authorization
        prov_auth = OAuth2::Provider::Authorization.new(@owner, 
          :response_type => 'token',
          :client_id => params[:client_id],
          :redirect_uri => client.redirect_uri,
          :scope => params[:scope]
        )

        unless prov_auth
          error! 'Unable to create authorization'
        end

        prov_auth.grant_access! # :duration => ?

        # Load the actual database model and present it
        auth = OAuth2::Model::Authorization.for(@owner, client)
        # We only get access to the access and refresh tokens
        # once, so we have to monkey-patch our database
        # model instance for presenting them
        present! auth,
          :access_token => prov_auth.access_token,
          :refresh_token => prov_auth.refresh_token
      end

      delete '/:id' do
        auth = @owner.authorizations.find(params[:id])
        unless auth
          error! 'Invalid authorization id'
        end
        auth.destroy

        status 204
      end
    end

    resource :users do
    end

    resource :snippets do # per-user
      get do
        authenticate!
        current_user.snippets
      end

      put do
        # replace all user's snippets with these new ones
      end
    
      post do
        # create a new snippet
      end

      delete do
        # delete all the user's snippets
      end

      get '/:id' do
        # return a specific snippet according to 
        # requested MIME type

        # something like Snippet.find(params[:id])
        # where we also narrow down by user
      end

      put '/:id' do
        # update the snippet with this new one
        # or create a new one altogether at this URI
      end

      post '/:id' do
        # this might be useful if we want to create
        # snippets that belong to a parent snippet
        # ie, 'folder'
      end

      delete '/:id' do
        # delete this snippet
      end
    end
  end
end