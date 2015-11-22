class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :write_access, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update]

  VOTE_SUCCESS_MSG = 'Your vote has been counted'
  VOTE_FAIL_MSG = 'You can not vote more than once for a Post'

  def index
    @posts = Post.limit(Post::POSTS_PER_PAGE).offset(params[:offset])
    @pages = (Post.all.size.to_f / Post::POSTS_PER_PAGE).ceil
  end

  def show
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.json {render json: {post: @post}}
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Your post has been created"
          redirect_to post_path(@post)
        end
      end
    else
      respond_to do |format|
        format.html { render 'new' }
      end
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
    @vote= Vote.create(vote: params[:vote], creator: current_user, voteable: @post)
    respond_to do |format|
      format.html do
        @vote.valid? ? flash[:notice] = VOTE_SUCCESS_MSG : flash[:error] = VOTE_FAIL_MSG
        redirect_to :back
      end
      format.js do
        @msg = @vote.valid? ? VOTE_SUCCESS_MSG : VOTE_FAIL_MSG
        render 'shared/vote'
      end
    end
  end

  private
  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def correct_user
    unless creator_logged_in? || authorised_access?('admin')
      flash[:error] = "You can not update someone else's post"
      redirect_to post_path(@post)
    end
  end

end
