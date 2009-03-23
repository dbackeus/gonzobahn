require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe SessionsController do
  
  before(:each) do
    @user = Factory(:user, :login => 'quentin', :password => 'test', :password_confirmation => 'test')
    @user.activate!
  end
  
  describe "successful login" do
    before(:each) do
      post :create, :login => 'quentin', :password => 'test'
    end
  
    it { should redirect_to(user_recordings_path(@user)) }
    it { should set_session(:user_id) }
  end
  
  describe "failed login" do
    before(:each) do
      post :create, :login => 'quentin', :password => 'bad password'
    end
  
    it { should respond_with(:success) }
    it { should render_template("new") }
    it { should set_the_flash.to(/failed/i) }
    it { should_not set_session(:user_id) }
  end
  
  describe "logout" do
    before(:each) do
      log_in
      get :destroy
    end
    
    it { should set_the_flash.to(/logged out/i) }
    it { should set_session(:user_id).to(nil) }
    it { should redirect_to(root_path) }
  end
  
  it 'remembers me' do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "1"
    response.cookies["auth_token"].should_not be_nil
  end
  
  it 'does not remember me' do
    post :create, :login => 'quentin', :password => 'test', :remember_me => "0"
    response.cookies["auth_token"].should be_nil
  end

  it 'deletes token on logout' do
    log_in(:quentin)
    get :destroy
    response.cookies["auth_token"].should == nil
  end

  it 'logs in with cookie' do
    @user.remember_me
    request.cookies["auth_token"] = cookie_for(@user)
    get :new
    controller.send(:logged_in?).should be_true
  end
  
  it 'fails expired cookie login' do
    @user.remember_me
    @user.update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(@user)
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  it 'fails cookie login' do
    @user.remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token user.remember_token
  end
end
