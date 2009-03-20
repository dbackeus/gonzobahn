class User::RecordingsController < ApplicationController
    
  # GET /recordings
  def index
    @recordings = user.recordings.all
  end
  
  private
  def user
    @user ||= User.find_by_login(params[:user_id])
  end
  helper_method :user
  
end
