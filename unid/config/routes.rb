Rails.application.routes.draw do

  root 'users#new'

  get '/auth/:provider', to: 'providers#authorize'

  get '/auth/:provider/callback', to: 'providers#callback'

  get '/reset_password', to: 'sessions#reset_request'
  post '/reset_password', to: 'sessions#reset_password'

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, except: %i(index new), path: '/' do
    resources :profiles, except: %i(index show)
  end

  get '/:id/:password/change_password', to: 'users#change_password'
  put '/:id/:password', to: 'users#update_password'
  patch '/:id/:password', to: 'users#update_password'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
