require 'rack/auth/basic'

module API
	module Helpers
	  module Auth
	  	# Returns the current user assuming proper Basic
	  	# or OAuth2 authorization has already occurred and passed
	    def current_user
	    	puts "inside: " + self.inspect.to_s
	    	unless @current_user
		    	auth = env["HTTP_AUTHORIZATION"]
		    	case
		    	when auth =~ /Basic (.*)/
		    		credentials = Rack::Auth::Basic::Request.new(env).credentials
		    		@current_user = User.authenticate(*credentials)
		    	when auth =~ /Bearer (.*)/, auth =~ /OAuth (.*)/
		    		# TODO: check out rack/auth/basic and implementing my own subclass
		    		#       or find a better way to reuse Grape's existing middleware
	    		end
	    	end
	    end

	    #def authenticate!
	    #  error!('401 Unauthorized', 401) unless current_user
	    #end
	  end
	end
end