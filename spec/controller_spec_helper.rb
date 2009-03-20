module ControllerSpecHelper
  def self.included(base)
    Factory(:user, :login => "controller_user") unless User.find_by_login("controller_user")
  end
  
  def log_in(login = "controller_user")
    raise "User fixture for #{email} not created" unless User.find_by_login(login)
    @current_user = User.find_by_login(login)
    session[:user_id] = @current_user.id
  end
  
  def current_user
    @current_user
  end
end