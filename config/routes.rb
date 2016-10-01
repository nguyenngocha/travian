Rails.application.routes.draw do
  get "my_villages/index"

  get "sessions/new"

  get "/checkip", to: "static_pages#home"

  get "/login", to: "sessions#new"

  root "sessions#new"

  post "/login", to: "sessions#create"

  resources :my_villages
  resources :lands
  resources :farms

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
