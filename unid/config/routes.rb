Rails.application.routes.draw do

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
