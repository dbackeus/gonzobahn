require File.dirname(__FILE__) + '/../../spec_helper'

describe "/recordings/edit.html.erb" do
  include RecordingsHelper
  
  before do
    @recording = mock_model(Recording)
    @recording.stub!(:title).and_return("MyString")
    @recording.stub!(:description).and_return("MyText")
    @recording.stub!(:filename).and_return("MyString")
    @recording.stub!(:user).and_return()
    assigns[:recording] = @recording
  end

  it "should render edit form" do
    render "/recordings/edit.html.erb"
    
    response.should have_tag("form[action=#{recording_path(@recording)}][method=post]") do
      with_tag('input#recording_title[name=?]', "recording[title]")
      with_tag('textarea#recording_description[name=?]', "recording[description]")
    end
  end
end


