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

    resources :people
    resources :investments
    resources :companies
  end

  scope "/deals" do
    get "/" => redirect("/deals/overview")
    get "/overview(/:year)" => "deals#overview",  as: :deals_overview
    get "/stream"           => "deals#index",     as: :deals
    # get "/:id"              => "deals#show",      as: :deal
  end

  resources :projects
  resources :investors

  root to: "home#promo", via: "get"
  post "/" => "home#subscribe"

  get "/subscribed"  => "home#subscribed"
  post "/subscribed" => "home#participate"
end
