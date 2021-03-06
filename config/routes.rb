Rails.application.routes.draw do

  root 'users#new'

  get 'google26905ab3a96605d7', to: 'about#google_verify'

  # get '/about', to: 'about#tos'
  get '/about/tos', to: 'about#tos'
  get '/about/privacy', to: 'about#privacy'
  get '/about/contact', to: 'about#contact'

  get '/users/find', to: 'users#search'

  get '/auth/reset_password', to: 'sessions#reset_request'
  post '/auth/reset_password', to: 'sessions#reset_password'
  resources :sessions, only: [:new, :create, :destroy], path: '/auth/sessions'

  get '/auth/:provider', to: 'providers#authorize'

  get '/auth/:provider/callback', to: 'providers#callback'

  resources :users, except: %i(index new), path: '/' do
    resources :profiles, except: %i(index show)
  end

  post '/:id/profiles/sort', to: 'profiles#sort'

  get '/:id/feed', to: 'profiles#feed', as: :feed

  get '/:id/delete', to: 'users#delete', as: :delete

  get '/:id/profiles/new/other', to: 'profiles#other', as: :other_profile

  get '/:id/:password/change_password', to: 'users#change_password'
  put '/:id/:password', to: 'users#update_password'
  patch '/:id/:password', to: 'users#update_password'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
