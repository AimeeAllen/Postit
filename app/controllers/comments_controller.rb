class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    #BUG because in-memory @comment is associated with in-memory @post
    # =>  when re-rendering the view, the part created comment is displayed
    @comment.creator = User.find(rand(1..3)) #TODO fix to pickup correct user

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

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end