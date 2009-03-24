class User::RecordingsController < ApplicationController
    
  # GET /recordings
  def index
    @recordings = user.recordings.by_created_at(:desc)
  end
  
  private
  def user
    @user ||= User.find_by_login(params[:user_id])
  end
  helper_method :user
  
end
