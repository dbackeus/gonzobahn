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
  
  describe "GET /forgot_password" do
    before(:each) do
      get :forgot_password
    end
    
    it { should respond_with(:success) }
  end
  
  describe "POST /forgot_password" do
    describe "with good email" do
      before(:each) do
        @user = Factory(:user)
        @user.activate!

        post :forgot_password, :user => { :email => @user.email }
      end

      it { should set_the_flash.to(translate("users.flash.forgot_password", :email => @user.email)) }
      it { should redirect_to(forgot_password_path) }
      
      it "should generate a reset code" do
        @user.reload.reset_code.should_not be_nil
      end
    end

    describe "with bad email" do
      before(:each) do
        post :forgot_password, :user => { :email => "anonexistingemail" }
      end
      
      it { should set_the_flash.to(translate("users.flash.forgot_password_fail", :email => "anonexistingemail")) }
      it { should respond_with(:success) }
    end
  end
  
  describe "GET /reset_password/:reset_code" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      @user.create_reset_code!
      
      get :reset_password, :reset_code => @user.reset_code
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:user).with(@user) }
  end
  
  describe "PUT /reset_password/:reset_code" do
    before(:each) do
      @user = Factory(:user)
      @user.activate!
      @user.create_reset_code!
    end
    
    describe "with good password" do
      before(:each) do
        put :reset_password, :reset_code => @user.reset_code, :user => { :password => "newpass", :password_confirmation => "newpass" }
      end
      
      it { should redirect_to(login_path) }
      it { should set_the_flash.to(translate("users.flash.reset_password", :login => @user.login)) }
    end
    
    describe "with messed up password confirmation" do
      before(:each) do
        put :reset_password, :reset_code => @user.reset_code, :user => { :password => "newpass", :password_confirmation => "wtf" }
      end
      
      it { should respond_with(:success) }
      it { should_not set_the_flash }
    end
    
    describe "without password" do
      before(:each) do
        put :reset_password, :reset_code => @user.reset_code, :user => {}
      end
      
      it { should respond_with(:success) }
      it { should set_the_flash.to(translate("users.flash.reset_password_missing_password")) }
    end
  end
  
  logged_in do
    
    describe "GET edit" do
      before(:each) do
        get :edit, :id => current_user.to_param
      end
      
      it { should respond_with(:success) }
    end
    
    describe "PUT update using openid" do
      
      it "should authenticate through openid" do
        @controller.expects(:authenticate_with_open_id)
        put :update, :id => current_user.id, :openid_identifier => "user.openidprovider.com"
      end
      
      describe "with successful authentication" do
        before(:each) do
          ActionController::Base.class_eval do
            private
            def begin_open_id_authentication(identity_url, options = {})
              yield OpenIdAuthentication::Result.new(:successful), identity_url
            end
          end
          put :update, :id => current_user.id, :openid_identifier => "user.openidprovider.com"
        end

        it { should redirect_to(edit_user_path(current_user)) }
        it { should set_the_flash.to(translate("users.flash.update")) }

        it "should assign the new identity_url to the user" do
          assigns(:user).identity_url.should == "user.openidprovider.com"
        end
      end
      
      describe "with failed authentication" do
        before(:each) do
          ActionController::Base.class_eval do
            private
            def begin_open_id_authentication(identity_url, options = {})
              yield OpenIdAuthentication::Result.new(:failed), identity_url
            end
          end
          put :update, :id => current_user.id, :openid_identifier => "user.openidprovider.com"
        end
        
        it { should set_the_flash }
        it { should render_template("edit") }
      end
      
    end
    
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
  
  describe "routes" do
    it "should accept usernames with dots" do
      route_for(:controller => "users", :action => "edit", :id => "david.backeus").should == "/users/david.backeus/edit"
      params_from(:get, "/users/david.backeus/edit").should == {:controller => "users", :action => "edit", :id => "david.backeus"}
    end
  end
end