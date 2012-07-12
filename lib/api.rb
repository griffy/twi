# Load the monkey-patched Grape::Entity class
require 'api/entity'

module API  
  module Helpers
    autoload :All, 'api/helpers/all'
    autoload :Auth, 'api/helpers/auth'
    autoload :Model, 'api/helpers/model'
    autoload :Resource, 'api/helpers/resource'
  end

  module Entities
    autoload :Authorization, 'api/entities/authorization'
    autoload :User, 'api/entities/user'
    autoload :Snippet, 'api/entities/snippet'
  end

  module Resources
    autoload :Authorizations, 'api/resources/authorizations'
  end
end