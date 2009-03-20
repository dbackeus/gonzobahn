require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  integrate_views
  
  before(:each) do
    Recording.any_instance.stubs(:move_file_to_public_dir)
    Recording.any_instance.stubs(:generate_thumbnail)
    Recording.any_instance.stubs(:delete_files)
  end
  
  describe "handling GET /recordings" do
    before(:each) do
      2.times { Factory(:recording) }
      get :index
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should assign all recordings for the view" do
      assigns[:recordings].should == Recording.all
    end
  end
  
  describe "handling GET /recordings/1" do
  
    before(:each) do
      @recording = Factory(:recording)
      get :show, :id => @recording.id
    end
  
    it "should be successful" do
      response.should be_success
    end
  
    it "should assign the recording for the view" do
      assigns[:recording].should == @recording
    end
  end
  
  describe "handling GET /recordings/new" do
  
    before(:each) do
      log_in
      get :new
    end
    
    it "should be successful" do
      response.should be_success
    end
  
    it "should assign a new recording for the view" do
      assigns[:recording].attributes.should == current_user.recordings.build.attributes
    end
  end
  
  describe "handling GET /recordings/1/edit" do
  
    before(:each) do
      log_in
      @recording = Factory(:recording, :user => current_user)
      get :edit, :id => @recording.id
    end
  
    it "should be successful" do
      response.should be_success
    end
    
    it "should assign the recording for the view" do
      assigns[:recording].should == @recording 
    end
  end
  
  describe "handling POST /recordings" do
  
    before(:each) do
      log_in
    end
    
    describe "with good attributes" do
  
      def do_post
        post :create, :recording => {
          :title => "Supermannen",
          :length => "34.233",
          :filename => "test.flv"
        }
      end
  
      it "should create a recording" do
        lambda { do_post }.should change(Recording, :count).by(1)
      end
  
      it "should redirect to the new recording" do
        do_post
        response.should redirect_to(recording_path(Recording.last))
      end
      
    end
    
    describe "with bad attributes" do
      
      def do_post
        post :create, :recording => {}
      end
      
      it "should not create a recording" do
        lambda { do_post }.should_not change(Recording, :count).by(1)
      end
      
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end
  
  describe "handling PUT /recordings/1" do
  
    before(:each) do
      log_in
      @recording = Factory(:recording, :user => current_user)
      @original_attributes = @recording.attributes
    end
  
    describe "with good attributes" do
  
      before(:each) do
        @good_attributes = { :title => "New title", :description => "New description" }
      end
  
      def do_put
        put :update, :id => @recording.id, :recording => @good_attributes
      end
  
      it "should update the found recording" do
        @original_attributes.should_not include(*@good_attributes.values)
        do_put
        @recording.reload.attributes.values.should include(*@good_attributes.values)
      end
  
      it "should assign the found recording for the view" do
        do_put
        assigns(:recording).should == @recording
      end
  
      it "should redirect to the recording" do
        do_put
        response.should redirect_to(recording_url(@recording))
      end
  
    end
    
    describe "with failed update" do
      
      before(:each) do
        @bad_attributes = { :title => nil, :description => 'This should not change' }
      end
      
      def do_put
        put :update, :id => @recording, :recording => @bad_attributes
      end
      
      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
      
      it "should not update the recording" do
        do_put
        @recording.reload.attributes.values.should_not include(@bad_attributes)
      end
      
    end
  end
  
  describe "handling DELETE /recordings/1" do
  
    before(:each) do
      log_in
      @recording = Factory(:recording, :user => current_user)
    end
  
    def do_delete
      delete :destroy, :id => @recording.id
    end
    
    it "should destroy the found recording" do
      Recording.find_by_id(@recording.id).should_not be_nil
      lambda { do_delete }.should change(Recording, :count).by(-1)
      Recording.find_by_id(@recording.id).should be_nil
    end
    
    it "should set the flash" do
      do_delete
      flash[:notice].should_not be_nil
    end
  
    it "should redirect to the user recordings list" do
      do_delete
      response.should redirect_to(user_recordings_url(@recording.user))
    end
  end
end