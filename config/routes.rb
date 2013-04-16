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
    resources :companies
  end

  resources :deals, only: %w[index]
  resources :people, only: %w[show]
  resources :projects, only: %w[index show]
  resources :investors, only: %w[index show]
  resources :statistics, only: %w[index]
  resources :researches, only: %w[index]
  resources :companies, only: %w[index show]
  resources :people, only: %w[show]
  resources :informers, only: %w[show]
  resources :authors, only: %w[show]

  get "/about" => "about#index"

  get "/search" => "search#index"
  get "/search/suggest" => "search#suggest"

  root to: "home#promo", via: "get"
  post "/" => "home#subscribe"

  get "/subscribed"  => "home#subscribed"
  post "/subscribed" => "home#participate"

  post "/markdown/preview" => "markdown#preview"
end
