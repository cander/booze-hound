Rails.application.routes.draw do
  devise_for :users
  get "tasks/daily"
  get "home/index", as: :home
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :olcc_bottles
  resources :olcc_stores
  resources :user
end
