module ControllerSpecHelper  
  def self.included(base)
    base.extend ClassMethods
  end
  
  def log_in(login = "controller_user")
    login = login.to_s
    Factory(:user, :login => login) unless User.find_by_login(login)
    @current_user = User.find_by_login(login)
    session[:user_id] = @current_user.id
  end
  
  def log_out
    session[:user_id] = nil
  end
  
  def current_user
    @current_user
  end
  
  def translate(key)
    controller.translate(key)
  end
  
  module ClassMethods
    def logged_in(&block)
      describe "logged in" do
        before(:each) do
          log_in
        end
      
        block.bind(self).call
      end
    end
    
    def logged_out(&block)
      describe "logged out" do
        before(:each) do
          log_out
        end

        block.bind(self).call
      end
    end
  end
end