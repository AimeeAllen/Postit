class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :write_access, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post has been created"
      redirect_to post_path(@post)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice]='Post successfully updated'
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def vote
    vote= Vote.create(vote: params[:vote], creator: current_user, voteable: @post)
    if vote.valid?
      flash[:notice] = 'Your vote has been counted'
    else
      flash[:error] = 'You can not vote more than once for a Post'
    end
    redirect_to :back
  end

  private
  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def correct_user
    unless creator_logged_in?
      flash[:error] = "You can not update someone else's post"
      redirect_to post_path(@post)
    end
  end

end
