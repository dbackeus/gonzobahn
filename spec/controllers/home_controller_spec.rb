require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  describe "GET index" do
    
    before(:each) do
      stub_recordings
      6.downto(1) { |i| Factory(:recording, :created_at => i.months.ago, :private => i.odd?) }
      get :index
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:recordings).with(Recording.published.recent) }
    
  end

end
