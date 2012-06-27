require 'rack/auth/basic'

module API
	module Helpers
	  module Auth
	  	# Returns the current user assuming proper Basic
	  	# or OAuth2 authentication has already occurred 
	  	# for the given resource and passed
	  	# TODO: This method relies on authentication occuring
	  	#       in headers, ignoring parameters
	    def current_user
	    	puts header[:http_authorization]
	    	unless @current_user
		    	auth = env["HTTP_AUTHORIZATION"]
		    	case
		    	when auth =~ /Basic (.*)/i
		    		credentials = Rack::Auth::Basic::Request.new(env).credentials
		    		@current_user = User.authenticate(*credentials)
		    	when auth =~ /Bearer (.*)/i, auth =~ /OAuth (.*)/i
		    		access_token = OAuth2::Router.access_token_from_request(env)
						#access_token = auth.match(/[Bearer|OAuth] (?<token>.*)/i)[:token]
						auth = OAuth2::Model.find_access_token(access_token)
						@current_user = auth.owner
	    		end
	    	end
	    	@current_user
	    end

	    def can(scope)
	    	# Make sure scope is an array, and add a few special
	    	# scopes to it that we always want to apply
	    	scopes = [[*scope], ["access_all"], ["access_#{namespace}"]]
		    scopes.each do |scope|
		    	# find the access token and make sure it's valid
				  token = OAuth2::Provider.access_token(nil, scope, env)
	        return true if token.valid?
      	end
	      # FIXME: update all errors to return actual formatted data
	      error!('401 Unauthorized', 401)
      end
	  end
	end
end