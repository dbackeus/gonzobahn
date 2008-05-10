require File.dirname(__FILE__) + '/../spec_helper'

describe Recording do
  before(:each) do
    @recording = Recording.new
  end

  it "should be valid" do
    @recording.should be_valid
  end
end
