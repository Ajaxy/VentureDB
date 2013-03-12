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
    resources :investors,  controller: :companies
    resources :angels,     controller: :people
    resources :users

    resources :subscriptions do
      member do
        post :approve
      end
    end

    resources :people
    resources :experts, controller: :people
    resources :investments
    resources :companies
    resources :sciences,         controller: :companies
    resources :infrastructures,  controller: :companies
    resources :events,           controller: :companies
    resources :innovations,      controller: :companies
    resources :events, except: %w[new]
  end

  resources :investors,  controller: :investors
  resources :angels,     controller: :investors
  resources :authors,    controller: :people
  resources :informers,    controller: :people

  resources :deals, only: %w[index]
  resources :projects, only: %w[index show]
  resources :investors, only: %w[index show]
  resources :statistics, only: %w[index]
  resources :researches, only: %w[index]
  resources :companies, only: %w[show]

  get "/search" => "search#index"
  get "/search/suggest" => "search#suggest"
  get "/search/suggest_connection" => "search#suggest_connection"
  get "/admin/:connection" => "deals#index", :constraints => {connection: /add.*\d/}

  root to: "home#promo", via: "get"
  post "/" => "home#subscribe"

  get "/subscribed"  => "home#subscribed"
  post "/subscribed" => "home#participate"

  post "/markdown/preview" => "markdown#preview"
end
