class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  before_filter :authenticate, :only => [:edit, :update]
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users/new_with_open_id
  def new_with_open_id
    authenticate_with_open_id params[:openid_identifier], :required => [:nickname, :email] do |result, identity_url, registration|
      if result.successful?
        @user = User.new(:identity_url => identity_url, :login => registration["nickname"], :email => registration["email"])
        flash.now[:notice] = t("users.flash.open_id")
      else
        flash[:error] = result.message
        redirect_to new_user_path
      end
    end
  end
  
  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  def create
    cookies.delete :auth_token
    
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      flash[:notice] = t("users.flash.create")
      redirect_to root_path
    else
      if @user.identity_url.present?
        render "new_with_open_id"
      else
        render "new"
      end
    end
  end
  
  # PUT /user/1
  def update
    @user = current_user
    
    if using_open_id?
      authenticate_with_open_id do |result, identity_url|
        if result.successful?
          @user.update_attribute :identity_url, identity_url
          flash[:notice] = t("users.flash.update")
          redirect_to edit_user_path(@user)
        else
          flash.now[:error] = result.message
          render "edit"
        end
      end
    else
      if @user.update_attributes(params[:user])
        flash[:notice] = t("users.flash.update")
        redirect_to edit_user_path(@user)
      else
        render "edit"
      end
    end
  end

  # GET /activate/ef97b7453727318bc3bfeeca1252471e48f98fd2
  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = translate("users.flash.activate")
    end
    redirect_to user_recordings_path(current_user)
  end

  # Forgot and reset password functionality cargo culted from http://railsforum.com/viewtopic.php?id=11962
  
  # GET /forgot_password
  def forgot_password
    if request.post?
      user = User.find_by_email(params[:user][:email])
      if user
        user.create_reset_code!
        flash[:notice] = t("users.flash.forgot_password", :email => user.email)
        redirect_to forgot_password_path
      else
        flash.now[:error] = t("users.flash.forgot_password_fail", :email => params[:user][:email])
      end
    end
  end
  
  # GET /forgot_password/ef97b7453727318bc3bfeeca1252471e48f98fd2
  def reset_password
    @user = User.find_by_reset_code(params[:reset_code])
    if request.put?
      if params[:user][:password].blank?
        flash.now[:error] = t("users.flash.reset_password_missing_password")
      elsif @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        @user.delete_reset_code!
        flash[:notice] = t("users.flash.reset_password", :login => @user.login)
        redirect_to login_path
      end
    end
  end

  # def suspend
  #   @user.suspend! 
  #   redirect_to users_path
  # end
  # 
  # def unsuspend
  #   @user.unsuspend! 
  #   redirect_to users_path
  # end
  # 
  # def destroy
  #   @user.delete!
  #   redirect_to users_path
  # end
  # 
  # def purge
  #   @user.destroy
  #   redirect_to users_path
  # end

  protected
  def find_user
    @user = User.find(params[:id])
  end

end
