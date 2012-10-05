Rails.application.routes.draw do

  mount EdgeAuth::Engine => "/edge-auth"

  root                                  :to => 'users#new'

  match '/signup',                      :to => 'users#new'
  match '/activate',                    :to => 'users#activate'
  match '/signin',                      :to => 'sessions#new'
  match '/signout',                     :to => 'sessions#destroy'

  match '/reset-password-mail-sent',    :to => 'pages#reset_password_mail_sent',
                                        :as => 'reset_password_mail_sent'

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
