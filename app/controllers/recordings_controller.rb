class RecordingsController < ApplicationController
  before_filter :authenticate, :except => [:show, :index, :file]
  
  protect_from_forgery :except => :auto_complete_for_recording_tag_list
  
  auto_complete_for :recording, :tag_list

  def auto_complete_for_recording_tag_list
    @words = params[:recording][:tag_list].split(',')
    
    all_tags = Tag.all(:order => 'name ASC')
    last_word = @words.pop.strip
    pattern = Regexp.new("^#{last_word}", "i")
    
    @tags = all_tags.select { |t| t.name.match pattern }

    render :layout => false
  end
  
  # GET /recordings/1/file
  def file
    @recording = Recording.find(params[:id])
    redirect_to "http://#{SITE_HOST}/system/recordings/#{@recording.id}/#{@recording.filename}" if allow_viewing?
  end
  
  # GET /recordings
  def index
    @recordings = Recording.published.by_created_at(:desc)
  end
  
  # GET /recordings/1
  def show
    @recording = Recording.find(params[:id])
    allow_viewing?
  end

  # GET /recordings/new
  def new
    @recording = current_user.recordings.build
  end

  # GET /recordings/1/edit
  def edit
    @recording = current_user.recordings.find(params[:id])
  end

  # POST /recordings
  def create
    @recording = current_user.recordings.build(params[:recording])

    if @recording.save
      flash[:notice] = 'Recording was successfully created.'
      redirect_to @recording
    else
      render "new"
    end
  end

  # PUT /recordings/1
  def update
    @recording = current_user.recordings.find(params[:id])

    if @recording.update_attributes(params[:recording])
      flash[:notice] = 'Recording was successfully updated.'
      redirect_to @recording
    else
      render "edit"
    end
  end

  # DELETE /recordings/1
  def destroy
    @recording = current_user.recordings.find(params[:id])
    @recording.destroy
    flash[:notice] = "Recording was succefully deleted"
    
    redirect_to user_recordings_path(@recording.user)
  end
  
  private
  def user
    User.find_by_login(params[:user_id])
  end
  
  def allow_viewing?
    return true unless @recording.private?
    
    if @recording.user != current_user
      access_denied("This recording is private and can only be seen by #{@recording.user}")
      false
    else
      true
    end
  end
end
