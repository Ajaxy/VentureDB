Venture::Application.routes.draw do
  devise_for :users, controllers: {
    registrations:  "users/registrations",
    passwords:      "users/passwords",
    sessions:       "users/sessions",
    confirmations:  "users/confirmations",
  }

  namespace :admin do
    root to: "deals#index"

    resources :deals do
      member do
        post :publish
        post :unpublish
      end
    end

    resources :projects
    resources :investors
    resources :users

    resources :subscriptions do
      member do
        post :approve
      end
    end

    resources :people
    resources :investments
    resources :events
  end

  resources :deals, only: %w[index]
  resources :projects, only: %w[index show]
  resources :investors, only: %w[index show]
  resources :statistics, only: %w[index]
  resources :researches, only: %w[index]

  get "/search" => "search#index"
  get "/search/suggest" => "search#suggest"

  root to: "home#promo", via: "get"
  post "/" => "home#subscribe"

  get "/subscribed"  => "home#subscribed"
  post "/subscribed" => "home#participate"
end
