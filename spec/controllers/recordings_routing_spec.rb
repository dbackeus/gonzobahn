require File.dirname(__FILE__) + '/../spec_helper'

describe RecordingsController do
  describe "route generation" do

    it "maps #index" do
      route_for(:controller => "recordings", :action => "index").should == "/recordings"
    end
  
    it "maps #new" do
      route_for(:controller => "recordings", :action => "new").should == "/recordings/new"
    end
  
    it "maps #show" do
      route_for(:controller => "recordings", :action => "show", :id => "1").should == "/recordings/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "recordings", :action => "edit", :id => "1").should == "/recordings/1/edit"
    end
  
    it "maps #create" do
      route_for(:controller => "recordings", :action => "create").should == {:path => "/recordings", :method => :post}
    end
  
    it "maps #update" do
      route_for(:controller => "recordings", :action => "update", :id => "1").should == {:path => "/recordings/1", :method => :put}
    end
  
    it "maps #destroy" do
      route_for(:controller => "recordings", :action => "destroy", :id => "1").should == {:path => "/recordings/1", :method => :delete}
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