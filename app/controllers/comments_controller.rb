class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Your comment was added"
    else
      flash[:notice] = "Can't create comment without a comment"
    end
    redirect_to @comment.commentable
  end
  
end
