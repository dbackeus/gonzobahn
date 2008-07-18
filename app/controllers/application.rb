# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all

  protect_from_forgery
  
  include AuthenticatedSystem
  
  #before_filter :fake_flash_messages
  
  private
  def fake_flash_messages
    flash.now[:notice] = "Testmeddelande"
    flash.now[:error] = "Testmeddelande"
  end
  
end
