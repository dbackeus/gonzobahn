# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  # render new.rhtml
  def new
  end

  def create
    if using_open_id?
      open_id_authentication
    else
      password_authentication
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = t("sessions.flash.destroy")
    redirect_to root_path
  end
  
  private
  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      if result.successful?
        self.current_user = User.authenticate_with_open_id(identity_url)
        if logged_in?
          successful_login
        else
          user = User.find_by_identity_url(identity_url)
          if user.nil?
            failed_login t("session.flash.open_id_user_not_found", :identity_url => identity_url)
          elsif !user.active?
            failed_login t("sessions.flash.activate_user")
          else
            failed_login
          end
        end
      else
        failed_login result.message
      end
    end
  end
  
  def password_authentication
    self.current_user = User.authenticate(params[:login], params[:password])
    
    if logged_in?
      successful_login
    else
      user = User.find_by_login(params[:login])
      if user.nil?
        failed_login t("sessions.flash.user_not_found")
      elsif !user.active?
        failed_login t("sessions.flash.activate_user")
      else
        failed_login
      end
    end
  end
  
  def successful_login
    if params[:remember_me] == "1"
      current_user.remember_me unless current_user.remember_token?
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
    
    flash[:notice] = t("sessions.flash.create")
    redirect_to user_recordings_path(current_user)
  end
  
  def failed_login(msg = t("sessions.flash.create_fail"))
    flash.now[:error] = msg
    render "new"
  end
end
