ActionController::Routing::Routes.draw do |map|

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.resources :users
  map.resource :session
  map.resource :comments, :only => :create

  map.namespace("user") do |user|
    user.resources :recordings, :only => :index, :path_prefix => "/:user"
  end
  
  map.resources :recordings, :collection => { :auto_complete_for_recording_tag_list => :post }, :member => { :file => :get }
  
  map.root :controller => "home"
  
end
