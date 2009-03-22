require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  
  before(:each) do
    stub_recordings
    log_in
  end
  
  describe "POST with good attributes" do
    
    before(:each) do
      @commentable = Factory(:recording)
      
      post :create, :comment => {
        :comment => "Awesome comment",
        :commentable_id => @commentable.id,
        :commentable_type => @commentable.class.to_s
      }
    end
    
    it { should set_the_flash.to(/was added/i) }
    it { should redirect_to(recording_path(@commentable)) }
    
    it "should create the comment" do
      Comment.count.should == 1
    end
    
    it "should belong to the current user" do
      Comment.last.user.should == current_user
    end
    
  end
  
  describe "POST with bad attributes" do
    
    before(:each) do
      @commentable = Factory(:recording)
      
      post :create, :comment => {
        :comment => "",
        :commentable_id => @commentable.id,
        :commentable_type => @commentable.class.to_s
      }
    end
    
    it { should set_the_flash.to(/without a comment/i) }
    it { should redirect_to(recording_path(@commentable)) }
    
    it "should not create a comment" do
      Comment.count.should == 0
    end
    
  end
  
end
