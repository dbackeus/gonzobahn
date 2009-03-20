require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe UsersController do

  it 'allows signup' do
    lambda do
      create_user
      response.should be_redirect
    end.should change(User, :count).by(1)
  end

  it 'signs up user in pending state' do
    create_user
    assigns(:user).reload
    assigns(:user).should be_pending
  end
  
  it 'signs up user with activation code' do
    create_user
    assigns(:user).reload
    assigns(:user).activation_code.should_not be_nil
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'activates user' do
    user = Factory.build(:user, :login => 'aaron', :password => 'test', :password_confirmation => 'test')
    user.register!
    user.save
    user.reload
    
    User.authenticate('aaron', 'test').should be_nil
    get :activate, :activation_code => user.activation_code
    User.authenticate('aaron', 'test').should == user
    flash[:notice].should_not be_nil
    response.should redirect_to('/')
  end
  
  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should be_nil
  end
  
  def create_user(options = {})
    post :create, :user => { 
      :login => 'quire', 
      :email => 'quire@example.com',
      :password => 'quire', 
      :password_confirmation => 'quire' 
    }.merge(options)
  end
end