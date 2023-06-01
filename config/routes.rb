Rails.application.routes.draw do
  get "tasks/daily"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :olcc_bottles
  resources :olcc_stores
end
