class UsersController < ApplicationController
  before_action :write_access, only: [:edit, :update]
  before_action :get_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      flash[:notice] = 'You have registered successfully, and are now logged-in'
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User update worked'
      # this is broken - won't redirect correctly
      render 'show'
      #redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:username,:password,:password_confirmation)
  end

  def get_user #fix this
    @user = User.where("lower(username)=lower(?)", params[:username]).first
    @user ||= User.find(params[:id])
  end

  def require_same_user
    if @user != current_user
      flash[:error] = 'You can not edit the profile of another user'
      redirect_to user_path(@user.username) #need id  once fix other named routes
    end
  end

end
