require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do

  describe "POST create" do
    
    describe "with good parameters" do
      before(:each) do
        post :create, :user => { 
          :login => 'quire', 
          :email => 'quire@example.com',
          :password => 'quire', 
          :password_confirmation => 'quire' 
        }
      end
      
      it { should redirect_to(root_path) }
      it { should set_the_flash.to(/thanks/i) }
      
      it "should create user" do
        User.count.should == 1
      end
      
      it "should create user in pending state" do
        assigns(:user).reload.should be_pending
      end
      
      it "should create user with activation code" do
        assigns(:user).reload.activation_code.should_not be_nil
      end
    end

    describe "with bad parameters" do
      before(:each) do
        post :create, :user => { 
          :login => nil, 
          :email => 'quire@example.com',
          :password => 'quire', 
          :password_confirmation => 'quire' 
        }
      end
      
      it { should_not set_the_flash }
      it { should render_template(:new) }
      
      it "should not create user" do
        User.count.should == 0
      end
    end
  end
  
  describe "GET activate" do
    it 'activates user' do
      user = Factory.build(:user, :login => 'aaron', :password => 'test', :password_confirmation => 'test')
      user.register!

      User.authenticate('aaron', 'test').should be_nil
      get :activate, :activation_code => user.activation_code
      User.authenticate('aaron', 'test').should == user
      flash[:notice].should_not be_nil
      response.should redirect_to(user_recordings_path(user))
    end

    it 'does not activate user with blank key' do
      get :activate, :activation_code => ''
      flash[:notice].should be_nil
    end
  end
  
  logged_out do
    
    describe "GET edit" do
      before(:each) do
        get :edit, :id => "1"
      end
      
      it { should deny_access }
    end
    
    describe "PUT update" do
      before(:each) do
        put :update, :id => "1"
      end
      
      it { should deny_access }
    end
    
  end
  
end