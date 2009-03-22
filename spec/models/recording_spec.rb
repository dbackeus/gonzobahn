require File.dirname(__FILE__) + '/../spec_helper'

describe Recording do
  
  before(:each) do
    Recording.any_instance.stubs(:move_file_to_public_dir)
    Recording.any_instance.stubs(:generate_thumbnail)
    Recording.any_instance.stubs(:delete_files)
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
