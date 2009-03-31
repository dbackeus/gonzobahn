require File.dirname(__FILE__) + '/../spec_helper'

describe Recording do
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:filename) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:length) }
  
  it { should have_many(:comments) }
  
  it { should have_named_scope(:recent).finding(:limit => 5, :order => "created_at desc") }
  it { should have_named_scope(:published).finding(:conditions => {:private => false}) }
  
  before(:each) do
    stub_recordings
  end
  
  it "should be createable" do
    Factory(:recording).should be_valid
  end
  
  describe "#thumbnail_path" do
    it "should use generic audio image if there is no video content" do
      recording = Factory(:recording, :has_video => false)
      recording.thumbnail_path.should == "/images/audio_recording.gif"
    end
    
    it "should use generated thumbnail if there is video content" do
      recording = Factory(:recording, :has_video => true)
      recording.thumbnail_path.should == "/system/recordings/#{recording.id}/image_original.jpg"
    end
  end
  
  it "should return time in 00:00 format" do
    recording = Factory(:recording)
    
    recording.length = 4.563
    recording.length_pretty.should == "00:05"
    
    recording.length = 67.356
    recording.length_pretty.should == "01:07"
  end
end
