require File.dirname(__FILE__) + '/../spec_helper'

describe Recording do
  it "should be createable" do
    Factory(:recording).should be_valid
  end
end
