Venture::Application.routes.draw do
  devise_for :users

  resources :people
  resources :companies
  resources :projects
  resources :investors
  resources :investments
  resources :deals

  root to: "deals#index"
end
