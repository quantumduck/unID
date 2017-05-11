Rails.application.routes.draw do

  get '/auth/uselessendpoint/1', to: 'profiles#oauth_experiment1'
  post '/auth/uselessendpoint/2', to: 'profiles#oauth_experiment2'
  get '/auth/uselessendpoint/trigger', to: 'profiles#oauth_trigger'

  get '/auth/:provider/callback', to: 'profiles#oauth_create'
  post '/auth/:provider/callback', to: 'profiles#oauth_create_post'

  root 'users#new'

  get '/:id/:password/change_password', to: 'users#change_password'

  resources :returns, only: [:show]

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, except: %i(index new), path: '/' do
    resources :profiles, except: %i(index show)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
