class CommentsController < ApplicationController
  
  before_filter :authenticate
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = translate("comments.flash.create")
    else
      flash[:error] = translate("comments.flash.create_fail")
    end
    redirect_to @comment.commentable
  end
  
end
