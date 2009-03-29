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

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      redirect_to root_path
      flash[:notice] = t("users.flash.create")
    else
      render "new"
    end
  end
  
  # PUT /user/1
  def update
    @user = current_user
    
    if @user.update_attributes(params[:user])
      flash[:notice] = t("users.flash.update")
      redirect_to edit_user_path(@user)
    else
      render "edit"
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

  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end

end
