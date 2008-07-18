class RecordingsController < ApplicationController
  before_filter :login_required, :except => :show
  
  protect_from_forgery :except => :auto_complete_for_recording_tag_list
  
  auto_complete_for :recording, :tag_list

  def auto_complete_for_recording_tag_list
    @words = params[:recording][:tag_list].split(',')
    
    all_tags = Tag.find(:all, :order => 'name ASC')
    last_word = @words.pop.strip
    pattern = Regexp.new("^#{last_word}", "i")
    
    @tags = all_tags.select { |t| t.name.match pattern }

    render :layout => false
  end
  
  # GET /recordings
  # GET /recordings.xml
  def index
    @recordings = current_user.recordings.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recordings }
    end
  end
  
  # GET /recordings/1
  # GET /recordings/1.xml
  def show
    @recording = Recording.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recording }
    end
  end

  # GET /recordings/new
  # GET /recordings/new.xml
  def new
    @recording = current_user.recordings.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recording }
    end
  end

  # GET /recordings/1/edit
  def edit
    @recording = current_user.recordings.find(params[:id])
  end

  # POST /recordings
  # POST /recordings.xml
  def create
    @recording = current_user.recordings.build(params[:recording])

    respond_to do |format|
      if @recording.save
        flash[:notice] = 'Recording was successfully created.'
        format.html { redirect_to(@recording) }
        format.xml  { render :xml => @recording, :status => :created, :location => @recording }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recordings/1
  # PUT /recordings/1.xml
  def update
    @recording = current_user.recordings.find(params[:id])

    respond_to do |format|
      if @recording.update_attributes(params[:recording])
        flash[:notice] = 'Recording was successfully updated.'
        format.html { redirect_to(@recording) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recording.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recordings/1
  # DELETE /recordings/1.xml
  def destroy
    @recording = current_user.recordings.find(params[:id])
    @recording.destroy

    respond_to do |format|
      format.html { redirect_to(recordings_url) }
      format.xml  { head :ok }
    end
  end
end
