Rails.application.routes.draw do

<<<<<<< HEAD
=======
  get '/auth/twitter/callback', to: 'profiles#twitter_create'
  get '/auth/linkedin/callback', to: 'profiles#linkedin_create', as: 'oauth_callback'
  get '/auth/failure', to: 'oauth#failure', as: 'oauth_failure'

  get '/auth/tumblr/callback', to: 'profiles#tumblr_create'

>>>>>>> master
  get '/auth/:provider', to: 'providers#authorize'

  get '/auth/:provider/callback', to: 'providers#callback'


  root 'users#new'

  get '/:id/:password/change_password', to: 'users#change_password'

  resources :returns, only: [:show]

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, except: %i(index new), path: '/' do
    resources :profiles, except: %i(index show)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
