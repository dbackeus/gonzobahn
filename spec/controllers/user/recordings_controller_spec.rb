require File.dirname(__FILE__) + '/../../spec_helper'

describe User::RecordingsController do
  integrate_views
  
  before(:each) do
    stub_recordings
    @user = Factory(:user, :login => "recordings_owner")
    @user_recordings = []
    5.downto(1) { |i| @user_recordings << Factory(:recording, :created_at => i.months.ago, :private => i.odd?, :user => @user ) }
    2.downto(1) { |i| Factory(:recording, :created_at => i.months.ago, :private => i.odd? ) }
  end
  
  describe "handling GET /username/recordings" do
    logged_in_as("recordings_owner") do
      before(:each) do
        get :index, :user => @user.login
      end
    
      it { should respond_with(:success) }
      it { should assign_to(:recordings).with(@user.recordings.by_created_at(:desc)) }
    end
    
    logged_in_as("impostor") do
      before(:each) do
        get :index, :user => @user.login
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:recordings).with(@user.recordings.published.by_created_at(:desc)) }
    end
  end
  
  describe "handling GET /username/recordings.atom" do
    logged_in_as("recordings_owner") do
      before(:each) do
        get :index, :format => "atom", :user => @user.login
      end
    
      it { should respond_with(:success) }
      it { should assign_to(:recordings).with(@user.recordings.published.by_created_at(:desc)) }
    end
  end
end