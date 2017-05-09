Rails.application.routes.draw do





  root 'users#new'

  # get '/:id/:password/change_password', to: 'users#change_password'

  # resources :sessions, only: [:new, :create, :destroy]
  #



  devise_for :users, only: :omniauth_callbacks, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_for :users, path: '/username', skip: [:registrations, :omniauth_callbacks], except: 'users/sessions#new', controllers: {
    sessions: 'users/sessions'
  }

  devise_for :users, path: '/', only: :registrations, controllers: {
    registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: %i(show edit update), path: '/' do
    resources :profiles, except: %i(index show)
  end
end
