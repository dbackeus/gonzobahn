require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do

  describe "GET new" do
    before(:each) do
      get :new
    end
    
    it { should assign_to(:user).with_kind_of(User) }
    it { should respond_with(:success) }
  end
  
  describe "POST new_with_open_id" do
    
    it "should authenticate with simple registration extension request" do
      @controller.expects(:authenticate_with_open_id).with("user.openidprovider.com", :required => [:nickname, :email])
      post :new_with_open_id, :openid_identifier => "user.openidprovider.com"
    end
    
    describe "with succesful openid authentication" do
      before(:each) do
        ActionController::Base.class_eval do
          private
          def begin_open_id_authentication(identity_url, options = {})
            yield OpenIdAuthentication::Result.new(:successful), identity_url, {"nickname" => "Reality", "email" => "reality@reality.com"}
          end 
        end
        post :new_with_open_id, :openid_identifier => "user.openidprovider.com"
      end
      
      it { should respond_with(:success) }      
      it { should set_the_flash.to(translate("users.flash.open_id")) }
      
      it "should assign a user with attributes from simple registration extension" do
        should assign_to(:user)
        assigns(:user).identity_url.should == "user.openidprovider.com"
        assigns(:user).login.should == "Reality"
        assigns(:user).email.should == "reality@reality.com"
      end
    end
    
    describe "with failed openid authentication" do
      before(:each) do
        ActionController::Base.class_eval do
          private
          def begin_open_id_authentication(identity_url, options = {})
            yield OpenIdAuthentication::Result.new(:failed), identity_url, {}
          end 
        end
        post :new_with_open_id, :openid_identifier => "user.openidprovider.com"
      end
      
      it { should set_the_flash }
      it { should redirect_to(new_user_path) }
    end
  end

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
      it { should set_the_flash.to(translate("users.flash.create")) }
      
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
          :email => "quire@example.com",
          :password => "quire", 
          :password_confirmation => "quire" 
        }
      end
      
      it { should assign_to(:user).with_kind_of(User) }
      it { should_not set_the_flash }
      it { should render_template(:new) }
      
      it "should not create user" do
        User.count.should == 0
      end
    end
    
    describe "with bad attributes using openid" do
      before(:each) do
        post :create, :user => { 
          :login => nil,
          :email => "quire@example.com",
          :identity_url => "http://user.openidprovider.com"
        }
      end

      it { should render_template("new_with_open_id") }
    end
  end
  
  describe "GET activate" do
    it 'activates user' do
      user = Factory.build(:user, :login => 'aaron', :password => 'test', :password_confirmation => 'test')
      user.register!

      User.authenticate('aaron', 'test').should be_nil
      get :activate, :activation_code => user.activation_code
      User.authenticate('aaron', 'test').should == user
      controller.should set_the_flash.to(translate("users.flash.activate"))
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