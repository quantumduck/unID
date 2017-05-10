Rails.application.routes.draw do

  get '/auth/:provider/callback', to: 'profiles#omniget'
  post '/auth/:provider/callback', to: 'sessions#omnipost'

  root 'users#new'

  get '/:id/:password/change_password', to: 'users#change_password'

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, except: %i(index new), path: '/' do
    resources :profiles, except: %i(index show)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
