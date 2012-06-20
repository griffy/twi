# Load the monkey-patched Grape::Entity class
require 'api/entity'

module API
  module Helpers
    autoload :Model, 'api/helpers/model'
    autoload :Resource, 'api/helpers/resource'
    autoload :Auth, 'api/helpers/auth'
  end

  module Entities
    autoload :Authorization, 'api/entities/authorization'
    autoload :User, 'api/entities/user'
    autoload :Snippet, 'api/entities/snippet'
  end
end