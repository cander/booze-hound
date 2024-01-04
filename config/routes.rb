Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "home/index", as: :home
  devise_for :users, controllers: {registrations: "registrations"}
  as :user do
    # after editing the profile, stay on the edit profile page as user_root
    get "users/profile", to: "devise/registrations#edit", as: :user_root
  end

  # Defines the root path route ("/")
  root "home#index"

  # bottles and stores aren't full CRUD - maybe not resources
  resources :olcc_bottles
  resources :olcc_stores

  get "tasks/daily"
end
