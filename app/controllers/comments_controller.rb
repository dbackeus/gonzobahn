class CommentsController < ApplicationController
  
  before_filter :authenticate
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Your comment was added"
    else
      flash[:error] = "Can't create comment without a comment"
    end
    redirect_to @comment.commentable
  end
  
end
