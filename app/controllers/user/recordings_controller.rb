class User::RecordingsController < ApplicationController
  
  # GET /recordings
  # GET /recordings.atom
  def index
    respond_to do |format|
      format.html { @recordings = accessable_recordings }
      format.atom { @recordings = user.recordings.published.by_created_at(:desc) }
    end
  end
  
  private
  def user
    @user ||= User.find_by_login(params[:user])
  end
  helper_method :user
  
  def accessable_recordings
    if user == current_user
      user.recordings.by_created_at(:desc)
    else
      user.recordings.published.by_created_at(:desc)
    end
  end
end
