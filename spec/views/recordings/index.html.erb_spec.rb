require File.dirname(__FILE__) + '/../../spec_helper'

describe "/recordings/index.html.erb" do
  include RecordingsHelper
  
  before(:each) do
    recording_98 = mock_model(Recording)
    recording_98.should_receive(:title).and_return("MyString")
    recording_98.should_receive(:description).and_return("MyText")
    recording_98.should_receive(:filename).and_return("MyString")
    recording_98.should_receive(:user).and_return()
    recording_99 = mock_model(Recording)
    recording_99.should_receive(:title).and_return("MyString")
    recording_99.should_receive(:description).and_return("MyText")
    recording_99.should_receive(:filename).and_return("MyString")
    recording_99.should_receive(:user).and_return()

    assigns[:recordings] = [recording_98, recording_99]
  end

  it "should render list of recordings" do
    render "/recordings/index.html.erb"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", '', 2)
  end
end

