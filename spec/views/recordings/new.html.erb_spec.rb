require File.dirname(__FILE__) + '/../../spec_helper'

describe "/recordings/new.html.erb" do
  include RecordingsHelper
  
  before(:each) do
    @recording = mock_model(Recording)
    @recording.stub!(:new_record?).and_return(true)
    @recording.stub!(:title).and_return("MyString")
    @recording.stub!(:description).and_return("MyText")
    @recording.stub!(:filename).and_return("MyString")
    @recording.stub!(:user).and_return()
    assigns[:recording] = @recording
  end

  it "should render new form" do
    render "/recordings/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", recordings_path) do
      with_tag("input#recording_title[name=?]", "recording[title]")
      with_tag("textarea#recording_description[name=?]", "recording[description]")
    end
  end
end


