module API
	module Entities
	  class Snippet < Grape::Entity
      expose :id
      expose_if_exists :url
      expose :title
      expose :content
      expose :visibility
      expose :updated_at
      expose :created_at
	  end
	end
end