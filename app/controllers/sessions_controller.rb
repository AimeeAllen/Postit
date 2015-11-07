class SessionsController < ApplicationController
  before_action :already_logged_in, only: [:new, :create]

  def new
  end
  def create
    if (user = User.find_by(username: params[:username])) && user.authenticate(params[:password])
      flash[:notice] = 'You have successfully logged in!'
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:error] = 'There was a problem with your username or password'
      render :new #login_path
    end
  end
  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have logged out'
    redirect_to root_path
  end

  private
  def already_logged_in
    if logged_in?
      flash[:notice] = 'You are already logged in'
      redirect_to root_path
    end
  end
end
