ActionController::Routing::Routes.draw do |map|

  map.with_options :controller => 'users' do |users|
    users.signup '/signup', :action => 'new'
    users.activate '/activate/:activation_code', :action => 'activate'
    users.forgot_password '/forgot_password', :action => 'forgot_password'
    users.reset_password '/reset_password/:reset_code', :action => 'reset_password'
  end
  
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.resources :users, :collection => { :new_with_open_id => :post }
  map.resource :session
  map.resource :comments, :only => :create

  map.namespace("user") do |user|
    user.resources :recordings, :only => :index, :path_prefix => "/:user"
  end
  
  map.resources :recordings, :collection => { :auto_complete_for_recording_tag_list => :post }, :member => { :file => :get }
  
  map.root :controller => "home"
  
end
