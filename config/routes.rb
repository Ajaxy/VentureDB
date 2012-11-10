Venture::Application.routes.draw do
  devise_for :users

  resources :projects
  resources :companies
  resources :people
  resources :deals

  root to: "deals#index"
end
