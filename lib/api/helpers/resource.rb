module API
	module Helpers
	  module Resource
	    def check_etag(etag)
	      error!('Not Modified', 304) if env['HTTP_ETAG'] == etag
	      header 'ETag', etag
	    end

	    def check_etag!
	      check_etag Time.now.day.to_s
	    end

	    def provides(attrs)
	    	attrs.each do |attr|
	        unless params.include? attr
	          error! "No #{attr.to_s} provided"
	        end
	      end
	    end
	  end
	end
end