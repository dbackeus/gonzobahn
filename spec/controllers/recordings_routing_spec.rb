require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  describe "route generation" do

    it "should map { :controller => 'recordings', :action => 'index' } to /recordings" do
      route_for(:controller => "recordings", :action => "index").should == "/recordings"
    end
  
    it "should map { :controller => 'recordings', :action => 'new' } to /recordings/new" do
      route_for(:controller => "recordings", :action => "new").should == "/recordings/new"
    end
  
    it "should map { :controller => 'recordings', :action => 'show', :id => 1 } to /recordings/1" do
      route_for(:controller => "recordings", :action => "show", :id => 1).should == "/recordings/1"
    end
  
    it "should map { :controller => 'recordings', :action => 'edit', :id => 1 } to /recordings/1/edit" do
      route_for(:controller => "recordings", :action => "edit", :id => 1).should == "/recordings/1/edit"
    end
  
    it "should map { :controller => 'recordings', :action => 'update', :id => 1} to /recordings/1" do
      route_for(:controller => "recordings", :action => "update", :id => 1).should == "/recordings/1"
    end
  
    it "should map { :controller => 'recordings', :action => 'destroy', :id => 1} to /recordings/1" do
      route_for(:controller => "recordings", :action => "destroy", :id => 1).should == "/recordings/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'recordings', action => 'index' } from GET /recordings" do
      params_from(:get, "/recordings").should == {:controller => "recordings", :action => "index"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'new' } from GET /recordings/new" do
      params_from(:get, "/recordings/new").should == {:controller => "recordings", :action => "new"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'create' } from POST /recordings" do
      params_from(:post, "/recordings").should == {:controller => "recordings", :action => "create"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'show', id => '1' } from GET /recordings/1" do
      params_from(:get, "/recordings/1").should == {:controller => "recordings", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'edit', id => '1' } from GET /recordings/1;edit" do
      params_from(:get, "/recordings/1/edit").should == {:controller => "recordings", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'update', id => '1' } from PUT /recordings/1" do
      params_from(:put, "/recordings/1").should == {:controller => "recordings", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'recordings', action => 'destroy', id => '1' } from DELETE /recordings/1" do
      params_from(:delete, "/recordings/1").should == {:controller => "recordings", :action => "destroy", :id => "1"}
    end
  end
end