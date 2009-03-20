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
end
