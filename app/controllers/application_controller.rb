class ApplicationController < ActionController::Base
  
  helper :all

  protect_from_forgery
  
  include AuthenticatedSystem
  
  before_filter :set_locale
  before_filter :set_time_zone
  #before_filter :fake_flash_messages
  
  private
  def set_locale
    session[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = session[:locale] if session[:locale].present?
  end
  
  def set_time_zone
    Time.zone = "Stockholm"
  end
  
  def fake_flash_messages
    flash.now[:notice] = "Testmeddelande"
    flash.now[:error] = "Testmeddelande"
  end
  
end
