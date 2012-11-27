Venture::Application.routes.draw do
  devise_for :users, controllers: {
    registrations:  "users/registrations",
    passwords:      "users/passwords",
    sessions:       "users/sessions",
    confirmations:  "users/confirmations",
  }

  scope "/admin", module: :admin do
    root to: "deals#index"
    resources :projects
    resources :people
    resources :companies
    resources :deals
    resources :investments
    resources :investors
  end

  scope "/deals" do
    get "/overview(/:year)" => "deals#overview", as: :cabinet_overview
    get "/"                 => "deals#index", as: :cabinet_deals
    get "/:id"              => "deals#show", as: :cabinet_deal
  end

  root to: "home#promo", via: "get"
  post "/" => "home#subscribe"
end
