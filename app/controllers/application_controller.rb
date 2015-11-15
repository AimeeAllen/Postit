class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :creator_logged_in?, :authorised_access?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def write_access
    unless logged_in?
      flash[:error] = 'You must login to do that action'
      redirect_to '/login'
    end
  end

  def creator_logged_in?
    current_user == @post.creator
  end

  def allow_access(*access_roles)
    access_denied unless authorised_access?(*access_roles)
  end

  def authorised_access?(*access_roles)
    logged_in? && access_roles.any? {|role| current_user.roles.to_s.include?(role)}
  end

  def access_denied
    flash[:error] = 'You do not have permission to do that!'
    redirect_to :back rescue redirect_to :root
  end
end
