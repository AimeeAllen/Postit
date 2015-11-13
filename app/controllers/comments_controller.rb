class CommentsController < ApplicationController
  before_action :write_access

  VOTE_SUCCESS_MSG = 'Your vote has been counted'
  VOTE_FAIL_MSG = 'You can not vote more than once for a Comment'

  def create
    @post = Post.find_by(slug: params[:post_id])
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
    comment = Comment.find(params[:id])
    @vote=Vote.create(vote: params[:vote], creator: current_user, voteable: comment)
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

  def comment_params
    params.require(:comment).permit(:body)
  end
end