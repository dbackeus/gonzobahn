require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  describe "GET index" do
    
    before(:each) do
      stub_recordings
      6.times { Factory(:recording) }
      get :index
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:recordings).with(Recording.recent) }
    
  end

end
