module EdgeAuth
  class ApplicationController < ActionController::Base
    protect_from_forgery
    include SessionsHelper
    include ApplicationHelper
  end
end
