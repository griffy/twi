#require File.expand_path('../entity', __FILE__)

module API::Entities
  class Authorization < Grape::Entity
    expose :id
    expose_if_exists :url
    expose :scopes
    expose_if_exists :access_token
    expose :expires_in
    expose_if_exists :refresh_token
    expose :updated_at
    expose :created_at
  end
end