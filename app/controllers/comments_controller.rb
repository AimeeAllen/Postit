class CommentsController < ApplicationController
  before_action :write_access

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user

    if !params[:agree]
      flash[:notice] = 'You must accept the terms for commenting'
      render 'posts/show'
    elsif @comment.save
      flash[:notice] = 'Comment was successfully posted!'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:format])
    vote=Vote.create(vote: params[:vote], creator: current_user, voteable: comment)
    if vote.valid?
      flash[:notice] = 'Your vote has been counted'
    else
      flash[:error] = "You can not vote more than once for a Comment"
    end
    redirect_to :back
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end