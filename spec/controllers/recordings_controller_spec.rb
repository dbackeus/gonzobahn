require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  integrate_views
  
  before(:each) do
    stub_recordings
  end
  
  describe "handling GET /recordings" do
    before(:each) do
      3.downto(1) { |i| Factory(:recording, :created_at => i.months.ago, :tag_list => i.odd? ? "test tags" : "") }
      Factory(:recording, :private => true)
    end
    
    describe "with tag parameter" do
      before(:each) do
        get :index, :tag => "tags"
      end

      it { should assign_to(:recordings).with(Recording.published.tagged_with("tags", :on => :tags).by_created_at(:desc)) }
    end
    
    describe "without tag parameter" do
      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should assign_to(:recordings).with(Recording.published.tagged_with(nil, :on => :tags).by_created_at(:desc)) }
    end
    
  end
  
  describe "handling GET /recordings.atom" do
    before(:each) do
      3.downto(1) { |i| Factory(:recording, :created_at => i.months.ago) }
      Factory(:recording, :private => true)
      get :index, :format => "atom"
    end
    
    it { should respond_with_content_type(:atom) }
  end
  
  describe "handling GET /recordings/1" do
    before(:each) do
      @recording = Factory(:recording)
      get :show, :id => @recording.id
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:recording).with(@recording) }
  end
  
  describe "handling GET /recordings/1.swf" do
    before(:each) do
      @recording = Factory(:recording)
    end
    
    it "should redirect to swf with internal=false" do
      get :show, :format => "swf", :id => @recording.id
      should redirect_to("http://#{SITE_HOST}/flash/recording_video_player.swf?host=#{SITE_HOST}&length=#{@recording.length}&recordingId=#{@recording.id}&internal=false")
    end
    
    it "should redirect to swf with internal=true" do
      get :show, :format => "swf", :id => @recording.id, :internal => "true"
      should redirect_to("http://#{SITE_HOST}/flash/recording_video_player.swf?host=#{SITE_HOST}&length=#{@recording.length}&recordingId=#{@recording.id}&internal=true")
    end
  end
  
  describe "handling GET /recordings/1/file" do
    before(:each) do
      @recording = Factory(:recording)
      get :file, :id => @recording.id
    end
    
    it { should redirect_to("http://#{SITE_HOST}/system/recordings/#{@recording.id}/#{@recording.filename}") }
    
    it "should increment number of views" do
      @recording.views.should == 0
      @recording.reload
      @recording.views.should == 1
    end
  end
  
  describe "handling GET /recordings/1 with private movie" do
  
    describe "with user of recording" do
      before(:each) do
        log_in
        recording = Factory(:recording, :private => true, :user => current_user)
        get :show, :id => recording.id
      end
      
      it { should respond_with(:success) }
    end
    
    describe "with an impostor" do
      before(:each) do
        log_in
        recording = Factory(:recording, :private => true)
        get :show, :id => recording.id
      end
      
      it { should redirect_to(login_path) }
      it { should set_the_flash.to(/privat/i) }
    end
  
  end
  
  logged_in do
    
    describe "handling GET /recordings/new" do
      before(:each) do
        get :new
      end
    
      it { should respond_with(:success) }
      it { should assign_to(:recording).with_kind_of(Recording) }
      
      it "should scope recording to logged in user" do
        assigns(:recording).user.should == current_user
      end
    end
    
    describe "handling GET /recordings/1/edit" do
      before(:each) do
        @recording = Factory(:recording, :user => current_user)
        get :edit, :id => @recording.id
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:recording).with(@recording) }
    end

    describe "handling POST /recordings" do

      describe "with good attributes" do
        before(:each) do
          post :create, :recording => {
            :title => "Supermannen",
            :length => "34.233",
            :filename => "test.flv"
          }
        end
        
        it { should redirect_to(recording_path(Recording.last)) }
        it { should set_the_flash.to(translate("recordings.flash.create")) }
        
        it "should create a recording" do
          Recording.count.should == 1
        end
      end

      describe "with bad attributes" do
        before(:each) do
          post :create, :recording => {}
        end
        
        it { should assign_to(:recording) }
        it { should render_template("new") }
        it { should_not set_the_flash }
        
        it "should not create a recording" do
          Recording.count.should == 0
        end
      end
    end

    describe "handling PUT /recordings/1" do
      
      before(:each) do
        @recording = Factory(:recording, :user => current_user, :title => "Old title", :description => "Old description")
        @original_attributes = @recording.attributes
      end

      describe "with good attributes" do
        before(:each) do
          @good_attributes = { :title => "New title", :description => "New description" }
          put :update, :id => @recording.id, :recording => @good_attributes
        end
        
        it { should assign_to(:recording).with(@recording) }
        it { should redirect_to(recording_url(@recording)) }
        it { should set_the_flash.to(translate("recordings.flash.update")) }
        
        it "should update the found recording" do
          @recording.reload.attributes.values.should include(*@good_attributes.values)
        end
      end

      describe "with failed update" do
        before(:each) do
          @bad_attributes = { :title => nil, :description => 'This should not change' }
            put :update, :id => @recording, :recording => @bad_attributes
        end
        
        it { should render_template("edit") }
        it { should_not set_the_flash }
        
        it "should not update the recording" do
          @recording.reload.attributes.values.should_not include(@bad_attributes)
        end
      end
    end

    describe "handling DELETE /recordings/1" do
      before(:each) do
        @recording = Factory(:recording, :user => current_user)
        delete :destroy, :id => @recording.id
      end
      
      it { should set_the_flash.to(translate("recordings.flash.destroy")) }
      it { should redirect_to(user_recordings_url(@recording.user)) }
      
      it "should destroy the found recording" do
        Recording.find_by_id(@recording.id).should be_nil
      end
    end
  end
  
  logged_out do
    
    describe "GET new" do
      before(:each) do
        get :new
      end
      it { should deny_access }
    end
    
    describe "GET edit" do
      before(:each) do
        get :edit, :id => "1"
      end
      it { should deny_access }
    end
    
    describe "PUT update" do
      before(:each) do
        put :update, :id => "1"
      end
      it { should deny_access }
    end
    
    describe "POST create" do
      before(:each) do
        post :create, :id => "1"
      end
      it { should deny_access }
    end
    
    describe "DELETE destroy" do
      before(:each) do
        delete :destroy, :id => "1"
      end
      it { should deny_access }
    end
  end
  
end