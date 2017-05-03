Rails.application.routes.draw do

  root 'users#new'

  resources :users, except: %i(index) do
    resources :cards, except: %i(index, show)
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
