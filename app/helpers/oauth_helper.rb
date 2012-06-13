module OauthHelper
  def permissions(scope)
    case scope
    when 'user_all'
      'Ability to create, edit, and delete user'
    when 'snippet_all'
      'Ability to create, edit, and delete snippets'
    end
  end
end
