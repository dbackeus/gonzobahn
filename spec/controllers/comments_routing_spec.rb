require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  
  describe "route generation" do
    
    it "maps #create" do
      route_for(:controller => "comments", :action => "create").should == {:path => "/comments", :method => :post}
    end
    
  end
  
  describe "route recognition" do
    it "should generate params for #create" do
      params_from(:post, "/comments").should == {:controller => "comments", :action => "create"}
    end
  end
  
end