class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :nothing => true
  end
end
