require File.dirname(__FILE__) + '/../../spec_helper'

describe "/recordings/show.html.erb" do
  include RecordingsHelper
  
  before(:each) do
    @recording = mock_model(Recording)
    @recording.stub!(:title).and_return("MyString")
    @recording.stub!(:description).and_return("MyText")
    @recording.stub!(:filename).and_return("MyString")
    @recording.stub!(:user).and_return()

    assigns[:recording] = @recording
  end

  it "should render attributes in <p>" do
    render "/recordings/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
    response.should have_text(/MyString/)
    response.should have_text(//)
  end
end

