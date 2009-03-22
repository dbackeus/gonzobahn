require File.dirname(__FILE__) + '/../spec_helper'

describe Recording do
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:filename) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:length) }
  it { should have_many(:comments) }
  
  before(:each) do
    stub_recordings
  end
  
  it "should be createable" do
    Factory(:recording).should be_valid
  end
  
  it "should return time in 00:00 format" do
    recording = Factory(:recording)
    
    recording.length = 4.563
    recording.length_pretty.should == "00:05"
    
    recording.length = 67.356
    recording.length_pretty.should == "01:07"
  end
end
