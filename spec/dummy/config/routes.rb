Rails.application.routes.draw do

  mount EdgeAuth::Engine => "/edge-auth"

  resources :identities

  root to: 'identities#new'
end
