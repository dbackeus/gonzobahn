class HomeController < ApplicationController
  
  def index
    @recordings = Recording.published.recent
  end
  
end
