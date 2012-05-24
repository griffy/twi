class SessionsController < ApplicationController
  before_filter :logged_in?, :only => [:destroy]

  def new
    respond_to do |format|
      format.html # new.html.erb
      # format.json { render json: @snippet }
    end
  end

  def create
  	user = User.find_by_email(params[:email])
  	logged_in = user && user.authenticate(params[:password])
  	if logged_in
  	  session[:user_id] = user.id
    end

    respond_to do |format|
      if logged_in
        format.html { redirect_to root_url, :notice => 'Logged in!' }
        # format.json { render json: "session", status: :created, id: user.id }
      else
        format.html { render :action => 'new', :notice => 'Invalid username or password' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	session[:user_id] = nil

  	respond_to do |format|
  	  format.html { redirect_to root_url, :notice => 'Logged out!' }
  	  # format.json { }
  	end
  end
end
