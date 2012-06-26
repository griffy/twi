require 'api/helpers/auth'
require 'api/helpers/model'
require 'api/helpers/resource'

# Tucks all the helpers into one neat module
module API
  module Helpers
    module All
      include API::Helpers::Auth
      include API::Helpers::Model
      include API::Helpers::Resource
    end
  end
end