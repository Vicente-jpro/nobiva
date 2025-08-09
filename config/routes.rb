require "resque/server"

Rails.application.routes.draw do
  mount Resque::Server.new, at: "/resque"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: { registrations: "registrations" }

  devise_scope :user do
    post "/users/sign_out", to: "devise/sessions#destroy"
  end

  resources :contacts, only: [ :create, :show ]
  resources :plans_selecteds
  resources :plans

  resources :favorite_lands, only: [ :index, :create, :destroy ]
  resources :favorite_houses, only: [ :index, :create, :destroy ]
  resources :profiles
  resources :profile_lands, only: [ :index ]
  resources :cities, only: [ :index ]
  get "/cities/province", to: "cities#province"



  resources :lands do
    get "show_images"

    collection do
      get "search"
    end
  end

  resources :houses do
    get "show_images"

    collection do
      get "buy"
      get "pending"
      get "rent"
      get "search"
      get "search_advanced"
    end

    member do
      post "pending_status"
    end
  end

  root "home#index"
end
