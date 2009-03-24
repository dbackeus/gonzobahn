class HomeController < ApplicationController
  
  def index
    @recordings = Recording.recent
  end
  
end
