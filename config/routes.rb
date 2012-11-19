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

  scope "/deals", controller: "deals" do
    root to: :directions, as: :cabinet_deals
    get "/directions(/:id)" => "deals#directions", as: :directions
    get :growth
    get :geography
    get :rounds
    get :stages
    get :instruments
  end

  root to: "home#index"
end
