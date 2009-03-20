module ControllerSpecHelper  
  def log_in(login = "controller_user")
    login = login.to_s
    Factory(:user, :login => login) unless User.find_by_login(login)
    @current_user = User.find_by_login(login)
    session[:user_id] = @current_user.id
  end
  
  def current_user
    @current_user
  end
end