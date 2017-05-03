Rails.application.routes.draw do

  root 'users#new'

  resources :users, only: %i(new create edit update destroy show) do
    resources :cards, only: %i(new create edit update destroy)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
