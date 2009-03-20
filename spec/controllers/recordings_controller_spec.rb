require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  describe "handling GET /recordings" do

    before(:each) do
      @recording = mock_model(Recording)
      Recording.stub!(:find).and_return([@recording])
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all recordings" do
      Recording.should_receive(:find).with(:all).and_return([@recording])
      do_get
    end
  
    it "should assign the found recordings for the view" do
      do_get
      assigns[:recordings].should == [@recording]
    end
  end

  describe "handling GET /recordings/1" do

    before(:each) do
      @recording = mock_model(Recording)
      Recording.stub!(:find).and_return(@recording)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the recording requested" do
      Recording.should_receive(:find).with("1").and_return(@recording)
      do_get
    end
  
    it "should assign the found recording for the view" do
      do_get
      assigns[:recording].should equal(@recording)
    end
  end

  describe "handling GET /recordings/new" do

    before(:each) do
      @recording = mock_model(Recording)
      Recording.stub!(:new).and_return(@recording)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new recording" do
      Recording.should_receive(:new).and_return(@recording)
      do_get
    end
  
    it "should not save the new recording" do
      @recording.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new recording for the view" do
      do_get
      assigns[:recording].should equal(@recording)
    end
  end

  describe "handling GET /recordings/1/edit" do

    before(:each) do
      @recording = mock_model(Recording)
      Recording.stub!(:find).and_return(@recording)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the recording requested" do
      Recording.should_receive(:find).and_return(@recording)
      do_get
    end
  
    it "should assign the found Recording for the view" do
      do_get
      assigns[:recording].should equal(@recording)
    end
  end

  describe "handling POST /recordings" do

    before(:each) do
      @recording = mock_model(Recording, :to_param => "1")
      Recording.stub!(:new).and_return(@recording)
    end
    
    describe "with successful save" do
  
      def do_post
        @recording.should_receive(:save).and_return(true)
        post :create, :recording => {}
      end
  
      it "should create a new recording" do
        Recording.should_receive(:new).with({}).and_return(@recording)
        do_post
      end

      it "should redirect to the new recording" do
        do_post
        response.should redirect_to(recording_url("1"))
      end
      
    end
    
    describe "with failed save" do

      def do_post
        @recording.should_receive(:save).and_return(false)
        post :create, :recording => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /recordings/1" do

    before(:each) do
      @recording = mock_model(Recording, :to_param => "1")
      Recording.stub!(:find).and_return(@recording)
    end
    
    describe "with successful update" do

      def do_put
        @recording.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the recording requested" do
        Recording.should_receive(:find).with("1").and_return(@recording)
        do_put
      end

      it "should update the found recording" do
        do_put
        assigns(:recording).should equal(@recording)
      end

      it "should assign the found recording for the view" do
        do_put
        assigns(:recording).should equal(@recording)
      end

      it "should redirect to the recording" do
        do_put
        response.should redirect_to(recording_url("1"))
      end

    end
    
    describe "with failed update" do

      def do_put
        @recording.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /recordings/1" do

    before(:each) do
      @recording = mock_model(Recording, :destroy => true)
      Recording.stub!(:find).and_return(@recording)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the recording requested" do
      Recording.should_receive(:find).with("1").and_return(@recording)
      do_delete
    end
  
    it "should call destroy on the found recording" do
      @recording.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the recordings list" do
      do_delete
      response.should redirect_to(recordings_url)
    end
  end
end