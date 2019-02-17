Rails.application.routes.draw do

  get "/checkip", to: "static_pages#home"

  root "sessions#new"

  get "/login", to: "sessions#new"

  post "/login", to: "sessions#create"

  delete "/logout",  to: 'sessions#destroy'

  get "/start", to: "static_pages#start"

  get "/stop", to: "static_pages#stop"

  resources :my_villages do
    resources :upgrate_schedules
    resources :troop_schedules
  end
  resources :lands
  resources :farms

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
