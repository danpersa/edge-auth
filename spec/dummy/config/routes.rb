Rails.application.routes.draw do

  mount EdgeAuth::Engine => "/edge-auth"
end
