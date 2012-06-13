class OauthController < ApplicationController
  before_filter :logged_in?, :only => [:authorize]

  def authorize
    @oauth2 = OAuth2::Provider.parse(current_user, env)

    if @oauth2.redirect?
      redirect_to @oauth2.redirect_uri, :status => @oauth2.response_status
    end

    response.headers.merge! @oauth2.response_headers # FIXME: should be = ?
    response.status = @oauth2.response_status
    
    respond_to do |format|
      format.html # authorize.html.erb
    end
  end

  def access_token
  end
end
