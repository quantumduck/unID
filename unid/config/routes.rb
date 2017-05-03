Rails.application.routes.draw do

  get 'users/new'

  get 'users/create'

  get 'users/show'

  root 'users#new'

  resources :sessions, only: [:new, :create, :destroy]

  resources :users, except: %i(index new), path: '/' do
    resources :cards, except: %i(index show)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
