Rails.application.routes.draw do
  get 'my_villages/index'

  get 'sessions/new'

  root 'static_pages#home'

  get "/login", to: "sessions#new"

  post "/login", to: "sessions#create"

  get "/index", to: "static_pages#index"

  resources :my_villages
  resources :lands

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
