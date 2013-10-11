Rails.application.routes.draw do

  mount EdgeAuth::Engine => "/edge-auth"

  root                                to: 'application#index', via: :get

  get '/signup',                      to: 'users#new'
  get '/activate',                    to: 'users#activate'
  get '/signin',                      to: 'sessions#new'
  get '/signout',                     to: 'sessions#destroy'

  get '/reset-password-mail-sent',    to: 'pages#reset_password_mail_sent',
                                      as: 'reset_password_mail_sent'

  resources :sessions, :only => [:new, :create, :destroy]

  resources :users

  resources :reset_passwords,
            :path => 'reset-password',
            :only => [:new, :create],
            # the new path is the same as the create path
            :path_names => {:new => ''}

  resources :change_reseted_passwords,
            :path => 'change-reseted-password',
            :only => [:edit, :create],
            # the edit path is the same as the create path
            :path_names => {:edit => ''}

  resources :change_passwords,
            :path => 'change-password',
            :only => [:new, :create],
            # the new path is the same as the create path
            :path_names => {:new => ''}                    
end
