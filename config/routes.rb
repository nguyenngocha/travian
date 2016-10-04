Rails.application.routes.draw do

  get "/checkip", to: "static_pages#home"

  root "sessions#new"

  get "/login", to: "sessions#new"

  post "/login", to: "sessions#create"

  delete "/logout",  to: 'sessions#destroy'

  resources :my_villages
  resources :lands
  resources :farms

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
